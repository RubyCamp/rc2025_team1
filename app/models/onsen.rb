class Onsen < ApplicationRecord
  has_many :reviews, dependent: :destroy

  has_many_attached :images

  validates :name, presence: true
  enum :style, { japanese: 0, western: 1 }
  validates :images,
  content_type: [ "image/jpeg", "image/png", "image/gif" ], # 許可ファイル形式
  size: { less_than: 5.megabytes },                       # 1枚あたり5MB未満
  limit: { max: 5 }                                     # 最大3枚まで
  serialize :holiday, type: Array, coder: JSON
  after_initialize do
    self.holiday ||= []
  end
  attr_accessor :weekday_open_time, :weekday_close_time, :weekend_open_time, :weekend_close_time
  before_validation :combine_weekday_hours

  private

  def combine_weekday_hours
    return if weekday_open_time.blank? && weekday_close_time.blank?
    if weekday_open_time.blank? || weekday_close_time.blank?
      errors.add(:base, "平日営業時間は両方入力してください")
      return
    end
    # フォーマット調整（例: "09:00 - 18:00"）
    self.weekday_hours = "#{weekday_open_time.strip} - #{weekday_close_time.strip}"
  end
  before_validation :combine_weekend_hours

  private
  def combine_weekend_hours
    return if weekend_open_time.blank? && weekend_close_time.blank?
    if weekend_open_time.blank? || weekend_close_time.blank?
      errors.add(:base, "土日営業時間は両方入力してください")
      return
    end
    self.weekend_hours = "#{weekend_open_time.strip} - #{weekend_close_time.strip}"
  end

  # @example Onsen.search(q: "玉造", tags: "露天風呂", lat: 35.1, lng: 132.5, radius_km: 10)
  def self.search(params)
    scope = all
    scope = apply_text_search(scope, params[:q])
    scope = apply_tag_search(scope, params[:tags])
    scope = apply_location_search(scope, params)
    scope = apply_pet_filter(scope, params[:pet])
    scope = apply_style_filter(scope, params[:style])
    scope = apply_serach_time_filter(scope, params[:search_time], params[:open_day])
    scope = apply_OpenDay_search(scope, params[:open_day])
    scope = apply_parking_filter(scope, params[:parking])
    scope
  end

  private_class_method

  # テキスト検索：名前・説明文の部分一致検索
  #
  # @param scope [ActiveRecord::Relation] 検索対象スコープ
  # @param query [String, nil] 検索クエリ
  # @return [ActiveRecord::Relation] 絞り込み後のスコープ
  def self.apply_text_search(scope, query)
    return scope unless query.present?

    q = query.strip
    scope.where("name ILIKE :q OR description ILIKE :q", q: "%#{q}%")
  end

  # タグ検索：カンマ区切りタグのOR条件検索
  #
  # @param scope [ActiveRecord::Relation] 検索対象スコープ
  # @param tags_param [String, nil] カンマ区切りタグ文字列
  # @return [ActiveRecord::Relation] 絞り込み後のスコープ
  def self.apply_tag_search(scope, tags_param)
    return scope unless tags_param.present?

    tags = tags_param.split(",").map(&:strip).reject(&:blank?)
    return scope unless tags.any?

    tag_query = tags.map { |_t| "tags ILIKE ?" }.join(" OR ")
    tag_values = tags.map { |t| "%#{t}%" }
    scope.where(tag_query, *tag_values)
  end

  # 位置情報検索：二段階フィルタによる距離絞り込み
  #
  # @param scope [ActiveRecord::Relation] 検索対象スコープ
  # @param params [Hash] 位置パラメータ（lat, lng, radius_km）
  # @return [ActiveRecord::Relation, Array<Onsen>] 絞り込み後の結果
  def self.apply_location_search(scope, params)
    return scope unless location_search_valid?(params)

    lat, lng, radius = extract_location_params(params)
    scope = apply_rectangular_filter(scope, lat, lng, radius)
    apply_precise_distance_filter(scope, lat, lng, radius)
  end

  # 位置検索パラメータの有効性チェック
  #
  # @param params [Hash] パラメータハッシュ
  # @return [Boolean] 有効な位置パラメータが揃っているか
  def self.location_search_valid?(params)
    params[:lat].present? && params[:lng].present? && params[:radius_km].present?
  end

  # 位置検索パラメータの抽出・正規化
  #
  # @param params [Hash] パラメータハッシュ
  # @return [Array<Float>] [緯度, 経度, 半径] の配列
  def self.extract_location_params(params)
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    radius = [ [ params[:radius_km].to_f, 1 ].max, 50 ].min  # 1-50km制限
    [ lat, lng, radius ]
  end

  # 第一段階：矩形範囲でデータベースレベル絞り込み
  #
  # @param scope [ActiveRecord::Relation] 検索対象スコープ
  # @param lat [Float] 基準緯度
  # @param lng [Float] 基準経度
  # @param radius [Float] 検索半径（km）
  # @return [ActiveRecord::Relation] 矩形範囲で絞り込み後のスコープ
  def self.apply_rectangular_filter(scope, lat, lng, radius)
    lat_delta = radius / 111.0  # 緯度1度≈111km
    lng_delta = radius / (111.0 * Math.cos(lat * Math::PI / 180))  # 経度補正

    scope.where(
      geo_lat: (lat - lat_delta)..(lat + lat_delta),
      geo_lng: (lng - lng_delta)..(lng + lng_delta)
    )
  end

  # 第二段階：厳密な球面距離計算による最終絞り込み
  #
  # @param scope [ActiveRecord::Relation] 矩形で絞り込み済みスコープ
  # @param lat [Float] 基準緯度
  # @param lng [Float] 基準経度
  # @param radius [Float] 検索半径（km）
  # @return [Array<Onsen>] 距離条件を満たす温泉配列
  def self.apply_precise_distance_filter(scope, lat, lng, radius)
    scope.select do |onsen|
      DistanceCalculatorService.calculate(lat, lng, onsen.geo_lat, onsen.geo_lng) <= radius
    end
  end
  # ペット可フィルタ
  def self.apply_pet_filter(scope, pet_param)
    return scope if pet_param.blank?

    pet_value = ActiveModel::Type::Boolean.new.cast(pet_param)
    scope.where(pet: pet_value)
  end
  # スタイルフィルタ
  def self.apply_style_filter(scope, style_param)
    return scope if style_param.blank?

    if Onsen.styles.key?(style_param)
      scope.where(style: Onsen.styles[style_param])
    else
      scope
    end
  end
  # 営業時間フィルタ
  def self.apply_serach_time_filter(scope, search_time_param, open_day_param)
    return scope if search_time_param.blank?
    search_time = Time.parse(search_time_param)
    if open_day_param.blank?
      scope.where("CAST(? AS time) BETWEEN CAST(split_part(weekend_hours, '-', 1) AS time)
                          AND CAST(split_part(weekend_hours, '-', 2) AS time)
                          OR
                          CAST(? AS time) BETWEEN CAST(split_part(weekday_hours, '-', 1) AS time)
                          AND CAST(split_part(weekday_hours, '-', 2) AS time)",
      search_time, search_time
      )
    else
      if open_day_param=="土"||open_day_param=="日"
        scope.where(
        "CAST(? AS time) BETWEEN CAST(split_part(weekend_hours, '-', 1) AS time)
                            AND CAST(split_part(weekend_hours, '-', 2) AS time)",
        search_time
      )
      else
        scope.where(
        "CAST(? AS time) BETWEEN CAST(split_part(weekday_hours, '-', 1) AS time)
                            AND CAST(split_part(weekday_hours, '-', 2) AS time)",
        search_time
      )
      end
    end
  end
  # 営業日フィルタ
  def self.apply_OpenDay_search(scope, open_day_param)
    return scope if open_day_param.blank?
    scope.where("holiday IS NULL OR holiday = '' OR holiday NOT LIKE ?", "%#{open_day_param}%")
  end
  # 駐車場フィルタ
  def self.apply_parking_filter(scope, parking_param)
    return scope if parking_param.blank?
    scope.where.not(parking: nil).where("parking > 0")
  end
end

class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user
  has_one_attached :image

  # ransackを使用する際、使用を制限するカラム
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # csv出力するメソッドを定義
  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"] # CSVデータにどの属性を、どの順番で出力するかを定義する
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|                    # CSV.generateを使ってCSVデータの文字列を生成する。この文字列がgenerate_csvクラスメソッドの戻り値となる
      csv << csv_attributes                                 # CSVの１行目としてヘッダを出力。定義したcsv_attributesを見出しとして使用
      all.each do |task|                                    # allメソッドで全タスクを取得
        csv << csv_attributes.map{ |attr| task.send(attr) } # 1レコードごとにCSVの１行を出力する。sendメソッドにattrを渡すことで、上記属性を順番に渡して、mapしている。
      end
    end
  end

  def self.import(file)                                    # 引数fileにアップロードされたファイルを受け取る
    CSV.foreach(file.path, headers: true) do |row|         # CSV一行ごとに読み込み処理を実施
      task = new                                           # CSV一行毎に、`Task.new`する。
      task.attributes = row.to_hash.slice(*csv_attributes) # 上記で生成したTaskインスタンスの各属性に、CSVの一行の情報を加工して入れ込む *csv_attributesはslice("name", "description", "created_at", "updated_at")と記述しているのと同じ
      task.save!                                           # DBに保存する（falseであれば例外を発生させる）
    end
  end

  scope :recent, -> { order(created_at: :desc) }

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end

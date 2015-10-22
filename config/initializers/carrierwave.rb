CarrierWave.configure do |config|

  config.ftp_host = "ftp.maxsnz.nichost.ru"
  config.ftp_port = 21
  config.ftp_user = "maxsnz_lovestockholm"
  config.ftp_passwd = "PV/bL3Ra"
  config.ftp_folder = ""
  config.ftp_url = "http://ccmbr.ru/uploads/lovestockholm/"
  config.ftp_passive = true # false by default

  config.enable_processing = false if Rails.env.test?
  config.cache_dir = 'system/tmp'
end

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end

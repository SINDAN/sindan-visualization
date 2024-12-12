# HostAuthorization
# for spec
Rails.application.config.hosts << ".example.com"

# for production
# Rails.application.config.hosts << 'fluentd.sindan-net.com'
Rails.application.config.hosts << /.*/

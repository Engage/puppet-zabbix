#
Facter.add('zabbix_psk_configured') do
    confine kernel: 'Linux'
    setcode do
    File.exists?('/etc/zabbix/.encryption_configured')
  end
end
# @summary This will create resources into puppetdb for automatically configuring agent into zabbix front-end.
# @param hostname Hostname of the machine
# @param ipaddress The IP address of the machine running zabbix agent.
# @param use_ip Use ipadress instead of dns to connect.
# @param port The port that the zabbix agent is listening on.
# @param group *Deprecated* (see groups parameter) Name of the hostgroup.
# @param groups An array of groups the host belongs to.
# @param group_create Whether to create hostgroup if missing.
# @param templates List of templates which should be attached to this host.
# @param macros Array of hashes (macros) which should be attached to this host.
# @param proxy Whether it is monitored by an proxy or not.
# @param interfacetype Internally used identifier for the host interface.
# @param interfacedetails Hash with interface details for SNMP when interface type is 2.
class zabbix::resources::agent (
  $hostname                              = undef,
  $ipaddress                             = undef,
  $use_ip                                = undef,
  $port                                  = undef,
  $group                                 = undef,
  Array[String[1]] $groups               = undef,
  $group_create                          = undef,
  $templates                             = undef,
  $macros                                = undef,
  $proxy                                 = undef,
  $tls_connect                           = undef,
  $tls_accept                            = undef,
  $tls_psk_identity                      = undef,
  $tls_psk                               = undef,
  $interfacetype                         = 1,
  $psk_configured                        = undef,
  Variant[Array, Hash] $interfacedetails = [],
  $zabbix_site                           = undef,
) {
  if $group and $groups {
    fail("Got group and groups. This isn't support! Please use groups only.")
  } else {
    if $group {
      warning('Passing group to zabbix::resources::agent is deprecated and will be removed. Use groups instead.')
      $_groups = Array($group)
    } else {
      $_groups = $groups
    }
  }
  if $psk_configured {
  #If file exists, create zabbix_host resource without psk values
    @@zabbix_host { $hostname:
      ipaddress        => $ipaddress,
      use_ip           => $use_ip,
      port             => $port,
      groups           => $_groups,
      group_create     => $group_create,
      templates        => $templates,
      macros           => $macros,
      proxy            => $proxy,
      interfacetype    => $interfacetype,
      interfacedetails => $interfacedetails,
      tls_connect      => $tls_connect,
      tls_accept       => $tls_accept,
      tag              => $zabbix_site,
    }
}
#Else, create file, and create zabbix_host resource with psk values
  else{
    @@zabbix_host { $hostname:
      ipaddress        => $ipaddress,
      use_ip           => $use_ip,
      port             => $port,
      groups           => $_groups,
      group_create     => $group_create,
      templates        => $templates,
      macros           => $macros,
      proxy            => $proxy,
      interfacetype    => $interfacetype,
      interfacedetails => $interfacedetails,
      tls_connect      => $tls_connect,
      tls_accept       => $tls_accept,
      tls_psk_identity => $tls_psk_identity,
      tls_psk          => $tls_psk,
      tag              => $zabbix_site,
    }
  }
}

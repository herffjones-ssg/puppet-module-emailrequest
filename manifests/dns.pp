define emailrequest::dns (
  $target_email = "ssgwinea@herffjones.com",
  $cc_email = "ssgwebteam@herffjones.com",
  $hostname,
  $ip,
){
  include common
  include sendmail


  if dnslookup($hostname) == [] {
    $message = dnscmd("$hostname", "$ip")

    if $message =~ /Fail/ {
      notify { "Unable to generate DNS command for $hostname + $ip. $message": }
    } else {
      exec{ "DNS_$hostname":
        command => "echo -e \'Please run the following to create DNS for ${hostname} - ${ip}:\n\n${message}\' | mail -s \"DNS for ${hostname}\" -c ${cc_email} -r ssgwebteam@herffjones.com ${target_email} && touch /tmp/${hostname}.requested",
        creates => "/tmp/${hostname}.requested",
        path    => ["/usr/bin", "/bin", "/usr/local/bin"],
      }
    }

  }
}

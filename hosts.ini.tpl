[redpanda]
%{ for i, ip in broker_public_ips ~}
${ ip != "" ? ip : broker_private_ips[i] } ansible_user=${ ssh_user } ansible_become=True private_ip=${broker_private_ips[i]}%{ if rack_awareness } rack=${rack[i]}%{ endif }%{ if tiered_storage_enabled } tiered_storage_bucket_name=${tiered_storage_bucket_name} cloud_storage_region=${cloud_storage_region}%{ endif }
%{ endfor ~}
%{ if enable_monitoring }

[monitor]
${ monitor_public_ip != "" ? monitor_public_ip : monitor_private_ip } ansible_user=${ ssh_user } ansible_become=True private_ip=${ monitor_private_ip }
%{ endif }

%{ if length(client_public_ips) > 0 }
[client]
%{ for i, ip in client_public_ips ~}
${ ip != "" ? ip : client_private_ips[i] } ansible_user=${ ssh_user } ansible_become=True private_ip=${client_private_ips[i]} id=${i}
%{ endfor ~}
%{ endif }

%{ if length(connect_public_ips) > 0 }
[connect]
%{ for i, ip in connect_public_ips ~}
${ ip != "" ? ip : connect_private_ips[i] } ansible_user=${ ssh_user } ansible_become=True private_ip=${connect_private_ips[i]} id=${i}
%{ endfor ~}
%{ endif }
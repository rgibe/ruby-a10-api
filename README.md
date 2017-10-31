## A10 Networks aXAPI with Ruby

A10 provides an aXAPI (REST) interface to configure and monitor the ACOS device.

Following the below reported documentation:
https://nettools.net.berkeley.edu/tools/docs/a10/thunder/ACOS_4_1_0/html/axapiv3/start_here.html

I implement a small ruby library/tool in order **to manage some operations on a Server Load Balancer**.

To actually do the job I also use the json configuration files in the "*config folder*".

In this repo you can find just few examples but I think **they should be enough to show you the way**.

## Manage Virtual Server

https://nettools.net.berkeley.edu/tools/docs/a10/thunder/ACOS_4_1_0/html/axapiv3/slb_virtual_server.html

For help just run the scripts:

- getVS.rb
- createVS.rb


## Manage Virtual Server Port

https://nettools.net.berkeley.edu/tools/docs/a10/thunder/ACOS_4_1_0/html/axapiv3/slb_virtual_server_port.html

For help just run the scripts:

- createVS_port.rb
- deleteVS_port.rb
- modifyVS_port.rb

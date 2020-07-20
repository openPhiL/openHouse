# Hypervisor Hardware

## My Setup

My main focus was to find a good balance between power consumption and "enough" power to run my smarthome.

I currently have 2 systems, a main server and a spare server.

### Main Server

For the main server, I selected the D3543-S3 because it can have a lot of rams and is running with very low TDP. It can have raid with 2 drives + nvme-storage for quick IO (when used with ZFS).

I have a 2TB HDD, which itself would be way to slow, but I have a 500GB Nvme SSD as a cache (40G W,460g R). So the server remains pretty responsive. If I would have the money, I would probably install 2 TB SSDs in a zfs mirror and a intel optane Nvme stick for the cache. 

### Spare Server

The spare server is what I had in the past, an old Gigabyte ga-c1007un-d with 8GB Ram. I have an 2TB HDD attached there as well and an older 120GB SSD for caching (40G W / 80G R). 


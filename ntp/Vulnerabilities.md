ntp vulnerabilties
==================

About CVE
---------

Common Vulnerabilities and Exposures(aka CVE) is a dictionary of common names for publicly known cybersecurity vulnerabilties.
CVE’s common, standardized identifiers provides reference points for data exchange so that information security products and 
services can speak with each other. CVE identifiers also provides a baseline for evaluating the coverage of tools and services 
so that users can determine which tools are most effective appropriate for their organization.

Description of application
--------------------------

The Network Time Protocol (NTP) is used to synchronize a computer's time
with another referenced time source. These packages include the ntpd
service which continuously adjusts system time and utilities used to query
and configure the ntpd service.

Version Matrix
--------------

This matrix depicts applications installed across various distributions available across organization.
With the help of package array listed below we will identify distribution and version based on Security fixes.
 
```
|-------------------------------|-----------|----------|----------|----------|----------|
| Package List                  | AWSLinux  |  CentOS  |  CentOS  |  Ubuntu  |  Ubuntu  |
|                               |  2016.09  | 7.3.1611 | 7.2.1511 |  16.04   |  14.04   | 
|-------------------------------|-----------|----------|----------|----------|----------|
| ntp-4.2.6p5                   |    √      |    √     |    √     |    √     |    √     |    
|-------------------------------|-----------|----------|----------|----------|----------|
```

Security Fix(es):
-----------------

1. CVE-2015-7979 : off-path denial of service on authenticated broadcast mode
1. CVE-2016-1547 : crypto-NAK preemptable association denial of service
1. CVE-2016-1548 : ntpd switching to interleaved mode with spoofed packets
1. CVE-2016-1550 : libntp message digest disclosure
1. CVE-2016-2518 : out-of-bounds references on crafted packet

Vulenarabilites Still exposed:
------------------------------

1. CVE-2016-4957 : ntpd in NTP before 4.2.8p8 allows remote attackers to cause a denial of service (daemon crash) via a crypto-NAK packet. NOTE: this vulnerability exists because of an incorrect fix for CVE-2016-1547.
1. CVE-2016-4956 : ntpd in NTP 4.x before 4.2.8p8 allows remote attackers to cause a denial of service (interleaved-mode transition and time change) via a spoofed broadcast packet. NOTE: this vulnerability exists because of an incomplete fix for CVE-2016-1548.
1. CVE-2016-4955 : ntpd in NTP 4.x before 4.2.8p8, when autokey is enabled, allows remote attackers to cause a denial of service (peer-variable clearing and association outage) by sending (1) a spoofed crypto-NAK packet or (2) a packet with an incorrect MAC value at a certain time.
1. CVE-2016-4954 : The process_packet function in ntp_proto.c in ntpd in NTP 4.x before 4.2.8p8 allows remote attackers to cause a denial of service (peer-variable modification) by sending spoofed packets from many source IP addresses in a certain scenario, as demonstrated by triggering an incorrect leap indication.
1. CVE-2016-4953 : ntpd in NTP 4.x before 4.2.8p8 allows remote attackers to cause a denial of service (ephemeral-association demobilization) by sending a spoofed crypto-NAK packet with incorrect authentication data at a certain time.
1. CVE-2015-7974 : NTP 4.x before 4.2.8p6 and 4.3.x before 4.3.90 do not verify peer associations of symmetric keys when authenticating packets, which might allow remote attackers to conduct impersonation attacks via an arbitrary trusted key, aka a "skeleton key."
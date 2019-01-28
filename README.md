# rubrik_recovery_report

# Overview
* Rubrik Script to report on Recovery Events between two dates

# Dependencies
* Ruby 2.4.x or greater
* Faraday Gem

# How to Use
```
ruby ./rubrik_recovery_report.rb --help
Usage: %prog [options]

Report options:
    -c, --cluster [Friendly Name]          Rubrik Cluster Friendly Name
    -f, --from [string]              Start Date (YYYY-mm-dd)
    -t, --to [string]                End Date (YYYY-mm-dd)
    -h, --help                       Show this message
    
You will be prompted for cluster details if they are not saved.
```

# Example credential definition (if credentials for --cluster do not yet exist):

```
Command - ruby./rubrik_recovery_report.rb -c amer2 --from 2019-01-24 --to 2019-01-25

Output - 

Credentials not found, prompting for details
Please enter Rubrik Node FQDNs/IPs for Cluster Name amer2 (comma delimited) : > amer2-rbk01.rubrikdemo.com
Please enter Username : > peter.milanese@rubrikdemo.com
Please enter Password : > 
Getting report data from Rubrik
Page 1
"Report was saved as amer2-2019-01-24~2019-01-25.csv"
```

# Example report generation:

```
Command -  ruby ./rubrik_recovery_report.rb -c amer2 --from 2019-01-026 --to 2019-01-27

Output - 

Getting report data from Rubrik
Page 1
"Report was saved as amer2-2019-01-026~2019-01-27.csv"

```

# Result File Excerpt

```
Mount Time, Object Name, Message
"Sat Jan 26 17:25:55 UTC 2019","am2-stevneka-w1","Unmounted vSphere VM 'am2-stevneka-w1 01-26 01:54 0'"
"Sat Jan 26 17:25:06 UTC 2019","am2-stevneka-w1","Mounted vSphere VM 'am2-stevneka-w1 01-26 01:54 0'"
"Sat Jan 26 03:44:18 UTC 2019","am2-adamturn-l1","Successfully restored 1 file(s)(total 5.66 MB) from snapshot of 'vSphere VM' 'am2-adamturn-l1' taken at 'Wed Nov 14 21:18:00 UTC 2018' in 3 seconds. Transfer rate was 1.73 MBps"
```

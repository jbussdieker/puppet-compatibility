list = <<-EOS
boxcutter/centos510                   (virtualbox, 1.0.17)
boxcutter/centos510-i386              (virtualbox, 1.0.17)
boxcutter/centos511                   (virtualbox, 1.0.17)
boxcutter/centos511-i386              (virtualbox, 1.0.17)
boxcutter/centos59                    (virtualbox, 1.0.16)
boxcutter/centos59-i386               (virtualbox, 1.0.16)
boxcutter/centos64                    (virtualbox, 1.0.17)
boxcutter/centos64-i386               (virtualbox, 1.0.17)
boxcutter/centos65                    (virtualbox, 1.0.17)
boxcutter/centos65-i386               (virtualbox, 1.0.17)
boxcutter/centos66                    (virtualbox, 1.0.17)
boxcutter/centos66-i386               (virtualbox, 1.0.17)
boxcutter/centos70                    (virtualbox, 1.0.17)
boxcutter/centos71                    (virtualbox, 1.0.17)
boxcutter/debian6010                  (virtualbox, 1.0.15)
boxcutter/debian6010-i386             (virtualbox, 1.0.15)
boxcutter/debian75                    (virtualbox, 1.0.15)
boxcutter/debian75-i386               (virtualbox, 1.0.15)
boxcutter/debian76                    (virtualbox, 1.0.15)
boxcutter/debian76-i386               (virtualbox, 1.0.15)
boxcutter/debian77                    (virtualbox, 1.0.15)
boxcutter/debian77-i386               (virtualbox, 1.0.15)
boxcutter/debian78                    (virtualbox, 1.0.15)
boxcutter/debian78-i386               (virtualbox, 1.0.15)
boxcutter/debian80                    (virtualbox, 1.0.15)
boxcutter/debian80-i386               (virtualbox, 1.0.15)
boxcutter/debian81                    (virtualbox, 1.0.15)
boxcutter/debian81-i386               (virtualbox, 1.0.15)
boxcutter/fedora18                    (virtualbox, 1.0.14)
boxcutter/fedora18-i386               (virtualbox, 1.0.14)
boxcutter/fedora19                    (virtualbox, 1.0.14)
boxcutter/fedora19-i386               (virtualbox, 1.0.14)
boxcutter/fedora20                    (virtualbox, 1.0.14)
boxcutter/fedora20-i386               (virtualbox, 1.0.14)
boxcutter/fedora21                    (virtualbox, 1.0.14)
boxcutter/fedora21-i386               (virtualbox, 1.0.14)
boxcutter/fedora22                    (virtualbox, 1.0.14)
boxcutter/oel510                      (virtualbox, 1.0.16)
boxcutter/oel510-i386                 (virtualbox, 1.0.16)
boxcutter/oel511                      (virtualbox, 1.0.16)
boxcutter/oel511-i386                 (virtualbox, 1.0.16)
boxcutter/oel57                       (virtualbox, 1.0.15)
boxcutter/oel57-i386                  (virtualbox, 1.0.15)
boxcutter/oel58                       (virtualbox, 1.0.15)
boxcutter/oel58-i386                  (virtualbox, 1.0.15)
boxcutter/oel59                       (virtualbox, 1.0.15)
boxcutter/oel59-i386                  (virtualbox, 1.0.15)
boxcutter/oel64                       (virtualbox, 1.0.16)
boxcutter/oel64-i386                  (virtualbox, 1.0.16)
boxcutter/oel65                       (virtualbox, 1.0.16)
boxcutter/oel65-i386                  (virtualbox, 1.0.16)
boxcutter/oel66                       (virtualbox, 1.0.16)
boxcutter/oel66-i386                  (virtualbox, 1.0.16)
boxcutter/oel70                       (virtualbox, 1.0.16)
boxcutter/oel71                       (virtualbox, 1.0.16)
boxcutter/ubuntu1004                  (virtualbox, 1.0.17)
boxcutter/ubuntu1004-i386             (virtualbox, 1.0.17)
boxcutter/ubuntu1204                  (virtualbox, 1.1.0)
boxcutter/ubuntu1204-i386             (virtualbox, 1.1.0)
boxcutter/ubuntu1404                  (virtualbox, 1.1.0)
boxcutter/ubuntu1404-i386             (virtualbox, 1.1.0)
boxcutter/ubuntu1410                  (virtualbox, 1.1.0)
boxcutter/ubuntu1410-i386             (virtualbox, 1.1.0)
boxcutter/ubuntu1504                  (virtualbox, 1.1.0)
boxcutter/ubuntu1504-i386             (virtualbox, 1.1.0)
EOS

def parse_release(release)
  platform = ""

  if release =~ /centos/
    platform += "el-"
    platform += release.match(/centos(\d)/).captures.first
  elsif release =~ /debian/
    platform += "debian-"
    platform += release.match(/debian(\d)/).captures.first
  elsif release =~ /fedora/
    platform += "fedora-"
    platform += release.match(/fedora(\d\d)/).captures.first
  elsif release =~ /oel/
    platform += "el-"
    platform += release.match(/oel(\d)/).captures.first
  elsif release =~ /ubuntu/
    platform += "ubuntu-"
    major, minor = release.match(/ubuntu(\d\d)(\d\d)/).captures
    platform += "#{major}.#{minor}"
  else
    raise "Unrecognized platform"
  end
    
  if release.end_with?("i386")
    platform += "-i386"
  else
    platform += "-x86_64"
  end

  platform
end

def build_yaml(name, platform)
"HOSTS:
  #{name}:
    roles:
      - master
    platform: #{platform}
    box : boxcutter/#{name}
    hypervisor : vagrant
CONFIG:
  log_level: trace
  quiet: true
  type: git
"
end

list.split("\n").each do |line|
  name = line.split(" ").first
  name = name.split("/").last

  platform = parse_release(name)
  raw = build_yaml(name, platform)

  puts "#{name}\t#{platform}"

  File.open("#{name}.yml", 'w') do |f|
    f.write(raw)
  end
end

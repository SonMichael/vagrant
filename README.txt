================== Kết quả ================== 

- Centos 7
- Php 7
- Php-fpm
- Mysql 5.7
- 2 user root và vagrant
- Nginx
- Vim, composer, bower, git, ... và 1 số cáo service cần thiết 
================Thực Hiện============================= 

- Đảm bảo virtualbox được install success
- Thay đổi các config trong vagrant/config/vagrant-local.example.yml và xóa file vagrant-local.yml
- Thay đổi thư mục mount trong Vagrant-file dòng: config.vm.synced_folder '~/code/bitbuget/run-vagrant/', '/app', owner: 'vagrant', group: 'vagrant'
- ping ip public xem có ai sử dụng ko 
- cài plugin 
 + vagrant plugin install vagrant-vbguest
 + vagrant plugin install vagrant-hostmanager
- chạy vagrant dưới quyền user ko phải root
- Nếu báo ko có quyền thì kiểm tra lại quyền mà các file terminal nó chửi
- Mỗi lần chạy vagrant up lỗi thì 
 + Xóa máy ảo ở virtual box
 + xóa .vagrant ở thư mục vagrant
 + xóa Cache ở /Users/sonle/.vagrant.d/tmp và file lock ở /Users/sonle/.vagrant.d/
 + Gõ vagrant destroy và gõ vagrant global-status để kiểm tra destroy hết chưa
 + kiểm tra /etc/host xóa  host add tự động



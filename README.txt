- Đảm bảo virtualbox được install success
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



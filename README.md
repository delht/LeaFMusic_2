### 1. Cài đặt thư viện

```bash
flutter pub get
```

### 2. Tạo file cấu hình môi trường

Tạo file `.env` ở thư mục gốc dự án (cùng cấp với pubspec.yaml) với nội dung ví dụ như sau:

```
IPv4=xxx.xxx.xxx.xxx
port=8080
```

- `IPv4`: Địa chỉ IP của server backend (API)
- `port`: Cổng backend (mặc định 8080 hoặc theo cấu hình server //Thường chạy trên local mới có)


### 3. Chạy ứng dụng

```bash
flutter run
```

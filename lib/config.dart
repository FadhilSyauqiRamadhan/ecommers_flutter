class Config {
  // Sesuaikan host/port sesuai docker-compose Anda.
  // Jika menjalankan emulator Android, gunakan 10.0.2.2 untuk mengakses host Windows.
  static const userBase = 'http://10.0.2.2:3001';
  static const productBase = 'http://10.0.2.2:3000'; // product-service
  static const cartBase    = 'http://10.0.2.2:3002'; // cart-service
  static const reviewBase  = 'http://10.0.2.2:5002'; // review-service (dari docker kamu)

}

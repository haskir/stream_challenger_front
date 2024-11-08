// Обработка перенаправления с Twitch
window.addEventListener('load', function() {
    const hash = window.location.hash;
    if (hash.startsWith('#access_token=')) {
      const token = hash.substring(14); // Извлечение JWT-токена
      window.location.href = 'index.html'; // Перенаправление на главную страницу
      // Отправка токена в Flutter-приложение
      window.flutter_inappwebview.postMessage(token);
    }
  });
  
  window.flutter_inappwebview.onMessage = function(event) {
    // Получение токена от Flutter
    const token = event.data;
    // Сохранение токена в Local Storage
    localStorage.setItem('jwtToken', token);
  };
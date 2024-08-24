// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'flowbite';

document.addEventListener('DOMContentLoaded', function () {
  // Функция для открытия модального окна
  function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove('hidden');
    }
  }

  // Обработка кнопок, открывающих модальные окна
  const modals = document.querySelectorAll('[data-modal-target]');
  modals.forEach(button => {
    button.addEventListener('click', function () {
      const modalId = button.getAttribute('data-modal-target');
      openModal(modalId);
    });
  });

  // Функция для отображения модального окна с QR-кодом
  window.showQrCodeModal = function(button) {
    const id = button.getAttribute('data-client-id');
    const url = `/clients/${id}/qr_code`;

    fetch(url)
      .then(response => response.text())
      .then(svg => {
        const qrCodeContainer = document.getElementById('qrCodeContainer');
        qrCodeContainer.innerHTML = svg;
        openModal('qrCodeModal');
      })
      .catch(error => console.error('Ошибка загрузки QR-кода:', error));
  };

  // Функция для закрытия модального окна с QR-кодом
  window.closeQrCodeModal = function() {
    const modal = document.getElementById('qrCodeModal');
    modal.classList.add('hidden');
  };

  // Обработка кнопок, закрывающих модальные окна
  const closeModalButtons = document.querySelectorAll('[data-modal-hide]');
  closeModalButtons.forEach(button => {
    button.addEventListener('click', function () {
      const modalId = button.getAttribute('data-modal-hide');
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.classList.add('hidden');
      }
    });
  });
});

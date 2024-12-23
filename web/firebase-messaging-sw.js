importScripts('https://www.gstatic.com/firebasejs/11.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.0.0/firebase-analytics-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
// эту часть берём из файла firebase_options.dart из переменной static const FirebaseOptions web
   apiKey: 'AIzaSyA6Apeks40yqvR2Nqsad09VE3W9B5gzVu8',
   appId: '1:703893638205:web:a5aa179b58777273f5ee54',
   messagingSenderId: '703893638205',
   projectId: 'stream-challenge-8cf2b',
   authDomain: 'stream-challenge-8cf2b.firebaseapp.com',
   storageBucket: 'stream-challenge-8cf2b.firebasestorage.app',
   measurementId: 'G-2PZ1',

});

const messaging = firebase.messaging();
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
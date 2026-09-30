self.addEventListener('push',e=>{
  const d=e.data?e.data.json():{title:'Compras en grupo',body:'Hay novedades'};
  e.waitUntil(self.registration.showNotification(d.title||'Compras en grupo',{body:d.body||'',icon:'icon.svg',badge:'icon.svg',data:{url:d.url||'./'}}));
});
self.addEventListener('notificationclick',e=>{e.notification.close();e.waitUntil(clients.openWindow(e.notification.data?.url||'./'))});
self.addEventListener('fetch',()=>{});

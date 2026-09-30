-- Compras en grupo · pegar en Supabase > SQL Editor
create table if not exists perfiles (
  id uuid primary key references auth.users on delete cascade,
  nombre text not null default '', negocio text not null default ''
);
create table if not exists ofertas (
  id uuid primary key default gen_random_uuid(),
  proveedor text not null, producto text not null, precio numeric not null,
  unidad text default 'unidad', cierra date not null, entrega date, minimo text, notas text,
  autor_id uuid not null references auth.users, estado text not null default 'abierta',
  creada_en timestamptz not null default now(), cerrada_en timestamptz
);
create table if not exists pedidos (
  oferta_id uuid references ofertas on delete cascade, uid uuid references auth.users on delete cascade,
  cantidad numeric not null, fecha date, nota text, actualizado timestamptz not null default now(),
  primary key (oferta_id, uid)
);
create table if not exists push_subs (
  uid uuid references auth.users on delete cascade, endpoint text, sub jsonb, primary key (uid, endpoint)
);
alter table perfiles enable row level security; alter table ofertas enable row level security;
alter table pedidos enable row level security; alter table push_subs enable row level security;
create policy "leer perfiles" on perfiles for select to authenticated using (true);
create policy "mi perfil" on perfiles for all to authenticated using (id = auth.uid()) with check (id = auth.uid());
create policy "leer ofertas" on ofertas for select to authenticated using (true);
create policy "publicar" on ofertas for insert to authenticated with check (autor_id = auth.uid());
create policy "editar mias" on ofertas for update to authenticated using (autor_id = auth.uid());
create policy "borrar mias" on ofertas for delete to authenticated using (autor_id = auth.uid());
create policy "leer pedidos" on pedidos for select to authenticated using (true);
create policy "mis pedidos" on pedidos for all to authenticated using (uid = auth.uid()) with check (uid = auth.uid());
create policy "mis push" on push_subs for all to authenticated using (uid = auth.uid()) with check (uid = auth.uid());
alter publication supabase_realtime add table ofertas, pedidos, perfiles;

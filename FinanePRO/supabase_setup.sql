-- Execute este script no SQL Editor do seu projeto no Supabase

-- Tabela de Categorias (Aluguel, Cartão Santander, etc)
create table if not exists categories (
  id uuid default gen_random_uuid() primary key,
  user_id uuid default auth.uid(),
  name text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Tabela de Contas Bancárias
create table if not exists bank_accounts (
  id uuid default gen_random_uuid() primary key,
  user_id uuid default auth.uid(),
  bank text not null,
  balance decimal default 0,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Tabela de Transações e Parcelas
create table if not exists transactions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid default auth.uid(),
  name text not null,
  amount decimal not null,
  category text not null,
  date timestamp with time zone not null,
  due_date timestamp with time zone not null,
  installments int default 1,
  installment_current int default 1,
  paid boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Habilitar RLS (Row Level Security) - Opcional, mas recomendado
alter table categories enable row level security;
alter table bank_accounts enable row level security;
alter table transactions enable row level security;

-- Políticas básicas para permitir que o usuário veja apenas seus dados (se usar autenticação)
create policy "Users can view their own categories" on categories for select using (auth.uid() = user_id);
create policy "Users can insert their own categories" on categories for insert with check (auth.uid() = user_id);

create policy "Users can view their own accounts" on bank_accounts for select using (auth.uid() = user_id);
create policy "Users can insert their own accounts" on bank_accounts for insert with check (auth.uid() = user_id);

create policy "Users can view their own transactions" on transactions for select using (auth.uid() = user_id);
create policy "Users can insert their own transactions" on transactions for insert with check (auth.uid() = user_id);

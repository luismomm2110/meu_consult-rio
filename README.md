# Meu Consultório

***

## Equipe

***

- Luis Antonio Momm Duarte
- Matheus Ferreira
- Santiago Nunes

## Funcionalidades

***

- Login e Senha para perfis de médicos e pacientes
- Médicos poderão registrar receitas, pacientes poderão ler
- Ambos poderão marcar ou cancelar consultas

## Pacotes utilizados

***

| Pacote | Versão | Função |
| ---| --- | --- |
| firebase_core | 1.6.0 | Pacote básico para utilizar o firebase |
| cloud_firestore | 2.5.3 | Persistência de banco de dados | 
| provider | 6.0.0 | Gerenciador de Estado para Widgets | 
| intl | 0.17.0 | Internacionalização de Medidas | 
| firebase_auth | 3.1.1 | Autenticação da database do Firebase |
| json_annotation | 4.4.0 | Anotações para serialização de Json | 

## Informações para execução

***

- flutter pub get 
- flutter run (o emulador pode dar alguns problemas, então talvez seja necessária mais de uma tentativa)
- criar usuários de classes Doctor e Paciente (conforme checkbox na página de Registro) 
- Marcar consultas e prescrever receitas e verificar nas telas dos recepientes dessas ações a lista
- Se desejar, limpar a memória do celular e ver que as informações persistem pois estão na Firestore



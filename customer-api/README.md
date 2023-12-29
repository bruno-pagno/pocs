<div style="text-align:center;height:90px,width:90px;">

# Customer API
API criada para um desafio de backend de programação documento recebido.

## Stack utilizada
- Node.js v14.18.3 (usar o comando `nvm use` caso tenha o [NVM](https://github.com/nvm-sh/nvm))
- Nest.js (CLI versão 9.5.0)
- Typescript
- Docker e Docker compose
- Redis

## Como rodar com docker
O comando `docker-compose up` Inicia o container da aplicação e do redis.
A aplicação roda na porta `3000` e o redis fica disponível na porta `6379`.

## Como rodar sem docker
É possível rodar a aplicação sem o Docker com o comando `npm start` ou `npm run start:dev` tendo o Redis rodando na porta 6379 da máquina host.

## Testes
Para executar os testes com o Jest basta rodar o comando `npm run test`

## Casos de uso 
### Salvar um cliente novo 
`POST` em `/customers` enviando name (string) e document (número)


Exemplo:
```
curl --location --request POST 'localhost:3000/customer' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "bruno",
    "document": 1234
}'
```

### Buscar um cliente por ID
`GET` em `/customers/:id` enviando id do cliente
Exemplo: 
```
curl --location --request GET 'localhost:3000/customer/a4a2a12e-4ac4-4343-9961-fbef99385348'
```

### Atualizar um cliente existente
`PUT` em `/customers/:id` enviando o id do cliente a ser a atualizado na URL e as propriedades a serem atualizadas: name (string), document (número) e id (string no formato de uuid)

Exemplo: 
```
curl --location --request PUT 'localhost:3000/customer/a4a2a12e-4ac4-4343-9961-fbef99385347' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id": "a4a2a12e-4ac4-4343-9961-fbef99385348"
}'
```

## Estrutura de arquivos

Explicação dos principais arquivos
```
src/
├── app.module.ts -> Módulo principal
├── clients -> Clients que fazem chamadas HTTP com Axios
│   ├── redis.client.ts -> Chamadas HTTP para o Keycloak para fazer SSO
│   └── sso.client.ts -> Chamadas HTTP para o Redis
├── customer.controller.spec.ts -> Teste do Controller dos clientes
├── customer.controller.ts -> Controller dos clientes
├── customer.service.ts -> Casos de uso utilizados pelo controller
├── domain
│   └── customer.ts -> Objeto de domínio de cliente
├── dto
│   ├── createCustomerDto.ts -> Dto para o caso de uso de criação
│   └── updateCustomerDto.ts -> Dto para o caso de uso de atualização
└── main.ts
Dockerfile/ -> Dockerfile para criar a aplicação Nest
docker-compose.yml/ -> Docker compose contendo Redis + aplicação
```

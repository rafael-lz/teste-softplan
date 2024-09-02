# Teste - Softplan

Este repositório contém o desafio de Delphi da Softplan.

## Requisitos

- Delphi 11 Alexandria: a versão CE já serve;
- [Visual C++](https://aka.ms/vs/17/release/vc_redist.x64.exe): por conta das libs do SQLite.

## Aspectos técnicos

### Liberação automática de objetos

Todas (ou quase todas) as classes implementam interfaces. Além de dar uso para a contagem de referência que o Delphi
aplica em objetos "interfaceados", ajuda também com o **DIP**.

### _DIP_ sempre que possível

Atributos, variáveis e argumentos são tipados via de regra com interfaces. Isto permite intercambialidade de
componentes, onde é possível mudar o tipo de implementação sem afetar as classes que as utilizam. O processamento dos
XMLs e JSONs de resposta da API é um exemplo. Ao invés de implementar um método para cada formato, a classe de consulta
recebe a instância do conversor a ser utilizado.

### Um pouco de _SRP_

As classes que efetuam as buscas por CEP e endereço tanto na base local quanto via API desempanham apenas uma tarefa e
nada mais.

### Imutabilidade

Atributos setados via construtores são validados e não podem ser alterados.

### Units como se fossem _namespaces_

Os nomes são compostos pela nome do projeto, módulo e classe ou interface. Pode haver uma quarta parte, usada para
implementações padrões, exceções ou rotinas.

## Módulos

```
TS
├── TS.Lib
├── TS.Modelo
├── TS.Aplicacao
├── TS.Persistencia.SQLite
├── TS.API.ViaCEP
├── TS.Cliente
└── TS.Cliente.VCL
```

- **TS.Lib**: Contém classes auxiliares;
- **TS.Modelo**: Contém a classe que representa o endereço. CEP e UF são _value objets_, pois podem ser reaproveitados
  por outras classes. Há também um _builder_ para validar e instanciar endereços;
- **TS.Aplicacao**: Contém as classes responsáveis pelas buscas de endereço na base local e via API. O _SRP_ entra
  também aqui, de modo que as classes não precisam usar o SQLite nem a API da ViaCEP diretamente;
- **TS.Persistencia.SQLite**: Contém a classe de persistência para o SQLite. Há também o _pool_ responsável por ajudá-la
  a obter a conexão do banco de dados;
- **TS.API.ViaCEP**: Contém a classe de consulta de endereços pela API da ViaCEP. Como dito anteriormente, o resultado é
  processado por classes à parte que são setadas ao instanciar a classe de consulta;
- **TS.Cliente**: Contém o gerador de instâncias das classes de busca de endereço. Além de gerá-las, é responsável por
  cuidar do intercambiamento de componentes que as classes utilizam como persistência e API;
- **TS.Cliente.VCL**: Telas e .DPR da aplicação.

## Execução

- Abrir o arquivo `src\TS.groupproj` e compilar tods os projetos. O executável é gerado na pasta `build\bin`;
- Copiar os arquivos das pastas `redist\x64` e `samples` para `build\bin`;
- Executar `build\bin\TS.Cliente.VCL.exe`.

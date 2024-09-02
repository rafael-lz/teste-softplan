DROP TABLE IF EXISTS endereco;

--endereco
CREATE TABLE IF NOT EXISTS endereco (
  codigo INTEGER NOT NULL,
  cep TEXT(8) NOT NULL,
  logradouro TEXT(100) NOT NULL,
  complemento TEXT(100),
  bairro TEXT(100) NOT NULL,
  localidade TEXT(100) NOT NULL,
  uf TEXT(2) NOT NULL,
  PRIMARY KEY(codigo AUTOINCREMENT)
);

CREATE UNIQUE INDEX idx_endereco_cep ON endereco (cep);
CREATE INDEX idx_endereco_endereco ON endereco (logradouro, localidade, uf);
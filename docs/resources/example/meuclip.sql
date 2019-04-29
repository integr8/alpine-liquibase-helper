-- -----------------------------------------------------
-- Table `VeiculosMidias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VeiculosMidias` (
  `codigoVeiculoMidia` INT NOT NULL AUTO_INCREMENT,
  `veiculoMidia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigoVeiculoMidia`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda o agrupamento de veículos de um cliente.';

-- -----------------------------------------------------
-- Table `Veiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Veiculos` (
  `codigoVeiculo` INT NOT NULL AUTO_INCREMENT,
  `codigoVeiculoMidia` INT NOT NULL,
  `nomeVeiculo` VARCHAR(45) NOT NULL,
  `hostnameVeiculo` VARCHAR(200) NOT NULL,
  `veiculoAtivo` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Este campo indica se o veículo está apto a varredura\n',
  `veiculoApagado` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`codigoVeiculo`, `codigoVeiculoMidia`),
  CONSTRAINT `veiculo_veiculoMidia_fk`
    FOREIGN KEY (`codigoVeiculoMidia`)
    REFERENCES `VeiculosMidias` (`codigoVeiculoMidia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os veículos monitorados pelo sistema.';

CREATE INDEX `veiculoMidia_idx` ON `Veiculos` (`codigoVeiculoMidia` ASC);

-- -----------------------------------------------------
-- Table `ClientesTipos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClientesTipos` (
  `codigoClienteTipo` INT NOT NULL AUTO_INCREMENT,
  `clienteTipo` VARCHAR(45) NOT NULL,
  `clienteTipoAtivo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`codigoClienteTipo`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os tipos possíveis de Clientes.';

-- -----------------------------------------------------
-- Table `Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Clientes` (
  `codigoCliente` INT NOT NULL AUTO_INCREMENT,
  `codigoClienteTipo` INT NOT NULL,
  `nomeCliente` VARCHAR(45) NOT NULL,
  `clienteAtivo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`codigoCliente`),
  CONSTRAINT `cliente_clienteTipo_fk`
    FOREIGN KEY (`codigoClienteTipo`)
    REFERENCES `ClientesTipos` (`codigoClienteTipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os clientes que tem acesso ao sistema.';

CREATE INDEX `clienteTipo_idx` ON `Clientes` (`codigoClienteTipo` ASC);

-- -----------------------------------------------------
-- Table `UrlsTipos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UrlsTipos` (
  `codigoURLTipo` INT NOT NULL AUTO_INCREMENT,
  `URLTipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigoURLTipo`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os tipos de Urls possíveis.';

-- -----------------------------------------------------
-- Table `UrlsStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UrlsStatus` (
  `codigoURLStatus` INT NOT NULL AUTO_INCREMENT,
  `URLStatus` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigoURLStatus`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os status possíveis de uma Url.';

-- -----------------------------------------------------
-- Table `Urls`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Urls` (
  `codigoURL` INT NOT NULL AUTO_INCREMENT,
  `codigoVeiculo` INT NOT NULL,
  `codigoURLTipo` INT NOT NULL,
  `codigoURLStatus` INT NOT NULL DEFAULT 0,
  `URL` TEXT NOT NULL,
  `hashURL` VARCHAR(32) NOT NULL,
  `tentativasCaptura` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`codigoURL`),
  CONSTRAINT `url_veiculo_fk`
    FOREIGN KEY (`codigoVeiculo`)
    REFERENCES `Veiculos` (`codigoVeiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `url_urlTipo_fk`
    FOREIGN KEY (`codigoURLTipo`)
    REFERENCES `UrlsTipos` (`codigoURLTipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `url_urlStatus_fk`
    FOREIGN KEY (`codigoURLStatus`)
    REFERENCES `UrlsStatus` (`codigoURLStatus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda todas as Urls que em algum momento virarão ou não uma notícia.';

CREATE INDEX `veiculo_idx` ON `Urls` (`codigoVeiculo` ASC);
CREATE INDEX `urlTipo_idx` ON `Urls` (`codigoURLTipo` ASC);
CREATE INDEX `urlStatus_idx` ON `Urls` (`codigoURLStatus` ASC);
CREATE INDEX `hashURL_idx` ON `Urls` (`hashURL` ASC);

-- -----------------------------------------------------
-- Table `Editorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Editorias` (
  `codigoEditoria` INT NOT NULL AUTO_INCREMENT,
  `editoria` VARCHAR(100) NOT NULL,
  `hashEditoria` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`codigoEditoria`))
ENGINE = InnoDB
COMMENT = 'Entidade  que guarda as editorias das notícias.';

CREATE INDEX `hashEditoria_idx` ON `Editorias` (`hashEditoria` ASC);
CREATE UNIQUE INDEX `hashEditoria_unq` ON `Editorias` (`hashEditoria` ASC);

-- -----------------------------------------------------
-- Table `Noticias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Noticias` (
  `codigoNoticia` INT NOT NULL AUTO_INCREMENT,
  `codigoEditoria` INT NOT NULL,
  `codigoURL` INT NOT NULL,
  `tituloNoticia` VARCHAR(200) NOT NULL,
  `dataPublicacao` TIMESTAMP NOT NULL,
  PRIMARY KEY (`codigoNoticia`, `codigoEditoria`, `codigoURL`),
  CONSTRAINT `noticia_editoria_fk`
    FOREIGN KEY (`codigoEditoria`)
    REFERENCES `Editorias` (`codigoEditoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `noticia_url_fk`
    FOREIGN KEY (`codigoURL`)
    REFERENCES `Urls` (`codigoURL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda as notícias do sistema.';

CREATE INDEX `noticiaEditoria_idx` ON `Noticias` (`codigoEditoria` ASC);
CREATE INDEX `noticiaUrl_idx` ON `Noticias` (`codigoURL` ASC);
CREATE INDEX `tituloNoticia_idx` ON `Noticias` (`tituloNoticia` ASC);

-- -----------------------------------------------------
-- Table `NoticiasChapeus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `NoticiasChapeus` (
  `codigoNoticiaChapeu` INT NOT NULL,
  `codigoNoticia` INT NOT NULL,
  `noticiaChapeu` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`codigoNoticiaChapeu`, `codigoNoticia`, `noticiaChapeu`),
  CONSTRAINT `noticiaChapeu_noticia_fk`
    FOREIGN KEY (`codigoNoticia`)
    REFERENCES `Noticias` (`codigoNoticia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda o chapéu da notícia';

CREATE INDEX `noticia_fk_idx` ON `NoticiasChapeus` (`codigoNoticia` ASC);

-- -----------------------------------------------------
-- Table `Jornalistas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Jornalistas` (
  `codigoJornalista` INT NOT NULL AUTO_INCREMENT,
  `nomeJornalista` VARCHAR(100) NOT NULL,
  `hashJornalista` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`codigoJornalista`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os jornalistas das notícias.';

CREATE INDEX `hashJornalista_idx` ON `Jornalistas` (`hashJornalista` ASC);
CREATE UNIQUE INDEX `hashJornalista_unq` ON `Jornalistas` (`hashJornalista` ASC);

-- -----------------------------------------------------
-- Table `Noticias_x_Jornalistas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Noticias_x_Jornalistas` (
  `codigoNoticia` INT NOT NULL,
  `codigoJornalista` INT NOT NULL,
  PRIMARY KEY (`codigoNoticia`, `codigoJornalista`),
  CONSTRAINT `noticiaJornalista_noticia_fk`
    FOREIGN KEY (`codigoNoticia`)
    REFERENCES `Noticias` (`codigoNoticia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `noticiaJornalista_jornalista_fk`
    FOREIGN KEY (`codigoJornalista`)
    REFERENCES `Jornalistas` (`codigoJornalista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Noticias e Jornalistas.';

CREATE INDEX `noticia_idx` ON `Noticias_x_Jornalistas` (`codigoNoticia` ASC);
CREATE INDEX `jornalista_idx` ON `Noticias_x_Jornalistas` (`codigoJornalista` ASC);

-- -----------------------------------------------------
-- Table `PalavrasChave`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PalavrasChave` (
  `codigoPalavraChave` INT NOT NULL AUTO_INCREMENT,
  `expressaoRegular` TEXT NOT NULL,
  `hashPalavraChave` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`codigoPalavraChave`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda todas as palavras-chave que o sistema buscará nas notícias varridas.';

CREATE INDEX `hashPalavraChave` ON `PalavrasChave` (`hashPalavraChave` ASC);

-- -----------------------------------------------------
-- Table `Clientes_x_Noticias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Clientes_x_Noticias` (
  `codigoCliente` INT NOT NULL,
  `codigoNoticia` INT NOT NULL,
  `codigoPalavraChave` INT NOT NULL,
  PRIMARY KEY (`codigoPalavraChave`, `codigoNoticia`, `codigoCliente`),
  CONSTRAINT `clienteNoticia_cliente_fk`
    FOREIGN KEY (`codigoCliente`)
    REFERENCES `Clientes` (`codigoCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clienteNoticia_palavraChave_fk`
    FOREIGN KEY (`codigoPalavraChave`)
    REFERENCES `PalavrasChave` (`codigoPalavraChave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Clientes e Noticias.';

CREATE INDEX `cliente_idx` ON `Clientes_x_Noticias` (`codigoCliente` ASC);
CREATE INDEX `palavraChave_fk_idx` ON `Clientes_x_Noticias` (`codigoPalavraChave` ASC);

-- -----------------------------------------------------
-- Table `NoticiasTextos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `NoticiasTextos` (
  `codigoNoticia` INT NOT NULL,
  `textoNoticia` LONGTEXT NOT NULL,
  PRIMARY KEY (`codigoNoticia`),
  CONSTRAINT `noticiaTexto_noticia_fk`
    FOREIGN KEY (`codigoNoticia`)
    REFERENCES `Noticias` (`codigoNoticia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os textos das notícias.';

CREATE UNIQUE INDEX `codigoNoticia_unq` ON `NoticiasTextos` (`codigoNoticia` ASC);

-- -----------------------------------------------------
-- Table `Assuntos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Assuntos` (
  `codigoAssunto` INT NOT NULL AUTO_INCREMENT,
  `assunto` VARCHAR(100) NOT NULL,
  `prioridadeAssunto` INT NOT NULL,
  PRIMARY KEY (`codigoAssunto`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os assuntos de cada cliente. Cada assunto é composto por uma ou mais palavras-chave.';

-- -----------------------------------------------------
-- Table `Clientes_x_Assuntos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Clientes_x_Assuntos` (
  `codigoClienteAssunto` INT NOT NULL AUTO_INCREMENT,
  `codigoCliente` INT NOT NULL,
  `codigoAssunto` INT NOT NULL,
  PRIMARY KEY (`codigoClienteAssunto`, `codigoAssunto`, `codigoCliente`),
  CONSTRAINT `clienteAssunto_cliente_fk`
    FOREIGN KEY (`codigoCliente`)
    REFERENCES `Clientes` (`codigoCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clienteAssunto_assunto_fk`
    FOREIGN KEY (`codigoAssunto`)
    REFERENCES `Assuntos` (`codigoAssunto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Clientes e Assuntos.';

CREATE INDEX `cliente_idx` ON `Clientes_x_Assuntos` (`codigoCliente` ASC);
CREATE INDEX `assunto_idx` ON `Clientes_x_Assuntos` (`codigoAssunto` ASC);

-- -----------------------------------------------------
-- Table `ClientesMidias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClientesMidias` (
  `codigoClienteMidia` INT NOT NULL AUTO_INCREMENT,
  `codigoCliente` INT NOT NULL,
  `nomeClienteMidia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigoClienteMidia`, `codigoCliente`),
  CONSTRAINT `clienteMidia_cliente_fk`
    FOREIGN KEY (`codigoCliente`)
    REFERENCES `Clientes` (`codigoCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda as mídias de um cliente.';

CREATE INDEX `midiaCliente_idx` ON `ClientesMidias` (`codigoCliente` ASC);

-- -----------------------------------------------------
-- Table `ClientesMidias_x_Veiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClientesMidias_x_Veiculos` (
  `codigoClienteMidia` INT NOT NULL,
  `codigoveiculo` INT NOT NULL,
  PRIMARY KEY (`codigoClienteMidia`, `codigoveiculo`),
  CONSTRAINT `clienteMidiaVeiculo_clienteMidia_fk`
    FOREIGN KEY (`codigoClienteMidia`)
    REFERENCES `ClientesMidias` (`codigoClienteMidia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clienteMidiaVeiculo_veiculo_fk`
    FOREIGN KEY (`codigoveiculo`)
    REFERENCES `Veiculos` (`codigoVeiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre ClientesMidias e Veiculos.';

CREATE INDEX `clienteMidia_idx` ON `ClientesMidias_x_Veiculos` (`codigoClienteMidia` ASC);
CREATE INDEX `veiculo_idx` ON `ClientesMidias_x_Veiculos` (`codigoveiculo` ASC);

-- -----------------------------------------------------
-- Table `Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Usuarios` (
  `codigoUsuario` INT NOT NULL AUTO_INCREMENT,
  `emailUsuario` VARCHAR(100) NOT NULL,
  `senhaUsuario` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`codigoUsuario`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os usuários com acesso ao sistema.';

CREATE UNIQUE INDEX `email_UNIQUE` ON `Usuarios` (`emailUsuario` ASC);

-- -----------------------------------------------------
-- Table `UsuariosPerfisCamposTipos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UsuariosPerfisCamposTipos` (
  `codigoCampoTipo` INT NOT NULL AUTO_INCREMENT,
  `campoTipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigoCampoTipo`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os tipos de dados dos campos do perfil do Usuário.';

-- -----------------------------------------------------
-- Table `UsuariosPerfisCampos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UsuariosPerfisCampos` (
  `codigoPerfilCampo` INT NOT NULL AUTO_INCREMENT,
  `codigoUsuarioPerfilCampoTipo` INT NOT NULL,
  `campoPerfil` VARCHAR(100) NOT NULL,
  `valorPadrao` VARCHAR(100) NULL,
  `obrigatoriedade` TINYINT(1) NOT NULL,
  PRIMARY KEY (`codigoPerfilCampo`, `codigoUsuarioPerfilCampoTipo`),
  CONSTRAINT `campoTipo_fk`
    FOREIGN KEY (`codigoUsuarioPerfilCampoTipo`)
    REFERENCES `UsuariosPerfisCamposTipos` (`codigoCampoTipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os campos possíveis para preenchimento do perfil do usuário.';

CREATE UNIQUE INDEX `campoPerfil_unq` ON `UsuariosPerfisCampos` (`campoPerfil` ASC);
CREATE INDEX `campoTipo_fk_idx` ON `UsuariosPerfisCampos` (`codigoUsuarioPerfilCampoTipo` ASC);

-- -----------------------------------------------------
-- Table `UsuariosPerfis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UsuariosPerfis` (
  `codigoUsuario` INT NOT NULL,
  `codigoUsuarioPerfilCampo` INT NOT NULL,
  `valorCampo` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`codigoUsuario`, `codigoUsuarioPerfilCampo`),
  CONSTRAINT `usuarioPerfil_usuarioPerfilCampo_fk`
    FOREIGN KEY (`codigoUsuarioPerfilCampo`)
    REFERENCES `UsuariosPerfisCampos` (`codigoPerfilCampo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `usuarioPerfil_usuario_fk`
    FOREIGN KEY (`codigoUsuario`)
    REFERENCES `Usuarios` (`codigoUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre usuarios e campos do perfil.';

CREATE INDEX `usuarioPerfilCampo_idx` ON `UsuariosPerfis` (`codigoUsuarioPerfilCampo` ASC);
CREATE INDEX `usuarios_idx` ON `UsuariosPerfis` (`codigoUsuario` ASC);

-- -----------------------------------------------------
-- Table `Clientes_x_Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Clientes_x_Usuarios` (
  `codigoCliente` INT NOT NULL,
  `codigoUsuario` INT NOT NULL,
  PRIMARY KEY (`codigoCliente`, `codigoUsuario`),
  CONSTRAINT `clienteUsuario_cliente_fk`
    FOREIGN KEY (`codigoCliente`)
    REFERENCES `Clientes` (`codigoCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clienteUsuario_usuario_fk`
    FOREIGN KEY (`codigoUsuario`)
    REFERENCES `Usuarios` (`codigoUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Clientes e Usuarios.';

CREATE INDEX `cliente_idx` ON `Clientes_x_Usuarios` (`codigoCliente` ASC);
CREATE INDEX `usuario_idx` ON `Clientes_x_Usuarios` (`codigoUsuario` ASC);

-- -----------------------------------------------------
-- Table `VeiculosPerfisCamposTipos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VeiculosPerfisCamposTipos` (
  `codigoVeiculoPerfilCampoTipo` INT NOT NULL AUTO_INCREMENT,
  `campoTipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigoVeiculoPerfilCampoTipo`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `VeiculosPerfisCampos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VeiculosPerfisCampos` (
  `codigoVeiculoPerfilCampo` INT NOT NULL AUTO_INCREMENT,
  `codigoVeiculoPerfilCampoTipo` INT NOT NULL,
  `veiculoPerfilCampo` VARCHAR(100) NOT NULL,
  `valorPadrao` VARCHAR(100) NULL,
  `obrigatorio` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`codigoVeiculoPerfilCampo`, `codigoVeiculoPerfilCampoTipo`),
  CONSTRAINT `veiculoPerfilCampo_veiculoPerfilCampoTipo_fk`
    FOREIGN KEY (`codigoVeiculoPerfilCampoTipo`)
    REFERENCES `VeiculosPerfisCamposTipos` (`codigoVeiculoPerfilCampoTipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os campos possíveis para preenchimento do perfil do veículo.';

CREATE INDEX `veiculoPerfilCampo_veiculoPerfilCampoTipo_fk_idx` ON `VeiculosPerfisCampos` (`codigoVeiculoPerfilCampoTipo` ASC);

-- -----------------------------------------------------
-- Table `VeiculosPerfis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VeiculosPerfis` (
  `codigoVeiculo` INT NOT NULL,
  `codigoVeiculoPerfilCampo` INT NOT NULL,
  `valorCampo` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`codigoVeiculo`, `codigoVeiculoPerfilCampo`),
  CONSTRAINT `veiculoPerfil_veiculo_fk`
    FOREIGN KEY (`codigoVeiculo`)
    REFERENCES `Veiculos` (`codigoVeiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `veiculoPerfil_veiculoPerfilCampo_fk`
    FOREIGN KEY (`codigoVeiculoPerfilCampo`)
    REFERENCES `VeiculosPerfisCampos` (`codigoVeiculoPerfilCampo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Veiculos e VeiculosPerfis.';

CREATE INDEX `veiculo_idx` ON `VeiculosPerfis` (`codigoVeiculo` ASC);
CREATE INDEX `veiculoPerfilCampo_idx` ON `VeiculosPerfis` (`codigoVeiculoPerfilCampo` ASC);

-- -----------------------------------------------------
-- Table `Produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produtos` (
  `codigoProduto` INT NOT NULL AUTO_INCREMENT,
  `produto` VARCHAR(45) NOT NULL,
  `produtoAtivo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`codigoProduto`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda todos os produtos disponíveis do sistema.';

-- -----------------------------------------------------
-- Table `Clientes_x_Produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Clientes_x_Produtos` (
  `codigoCliente` INT NOT NULL,
  `codigoProduto` INT NOT NULL,
  PRIMARY KEY (`codigoCliente`, `codigoProduto`),
  CONSTRAINT `clienteProduto_cliente_fk`
    FOREIGN KEY (`codigoCliente`)
    REFERENCES `Clientes` (`codigoCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clienteProduto_produto_fk`
    FOREIGN KEY (`codigoProduto`)
    REFERENCES `Produtos` (`codigoProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Clientes e Produtos.';

CREATE INDEX `cliente_fk_idx` ON `Clientes_x_Produtos` (`codigoCliente` ASC);
CREATE INDEX `produtos_fk_idx` ON `Clientes_x_Produtos` (`codigoProduto` ASC);

-- -----------------------------------------------------
-- Table `UsuariosDireitos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UsuariosDireitos` (
  `codigoUsuarioDireito` INT NOT NULL AUTO_INCREMENT,
  `direitoUsuario` VARCHAR(45) NOT NULL,
  `direitoUsuarioAtivo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`codigoUsuarioDireito`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os direitos dos usuários ao sistema.';

-- -----------------------------------------------------
-- Table `Usuarios_x_UsuariosDireitos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Usuarios_x_UsuariosDireitos` (
  `codigoUsuario` INT NOT NULL AUTO_INCREMENT,
  `codigoUsuarioDireito` INT NOT NULL,
  PRIMARY KEY (`codigoUsuario`, `codigoUsuarioDireito`),
  CONSTRAINT `usuarioUsuarioDireito_usuario_fk`
    FOREIGN KEY (`codigoUsuario`)
    REFERENCES `Usuarios` (`codigoUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `usuarioUsuarioDireito_usuarioDireito_fk`
    FOREIGN KEY (`codigoUsuarioDireito`)
    REFERENCES `UsuariosDireitos` (`codigoUsuarioDireito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Usuarios e UsuariosDireitos.';

CREATE UNIQUE INDEX `codigoUsuario_UNIQUE` ON `Usuarios_x_UsuariosDireitos` (`codigoUsuario` ASC, `codigoUsuarioDireito` ASC);
CREATE INDEX `usuarioDireito_fk_idx` ON `Usuarios_x_UsuariosDireitos` (`codigoUsuarioDireito` ASC);

-- -----------------------------------------------------
-- Table `AvaliacoesTipos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AvaliacoesTipos` (
  `codigoAvaliacaoTipo` INT NOT NULL AUTO_INCREMENT,
  `avaliacaoTipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigoAvaliacaoTipo`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os tipos possíveis de avaliações, possibilitando classificar um texto como positivo, negativo ou neutro.';

-- -----------------------------------------------------
-- Table `Avaliacoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Avaliacoes` (
  `codigoNoticia` INT NOT NULL,
  `codigoAvaliacaoTipo` INT NOT NULL,
  PRIMARY KEY (`codigoNoticia`, `codigoAvaliacaoTipo`),
  CONSTRAINT `avaliacao_noticia_fk`
    FOREIGN KEY (`codigoNoticia`)
    REFERENCES `Noticias` (`codigoNoticia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `avaliacao_avaliacaoTipo_fk`
    FOREIGN KEY (`codigoAvaliacaoTipo`)
    REFERENCES `AvaliacoesTipos` (`codigoAvaliacaoTipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda a avaliação de uma notícia.';

CREATE INDEX `noticia_idx` ON `Avaliacoes` (`codigoNoticia` ASC);
CREATE INDEX `avaliacaoTipo_idx` ON `Avaliacoes` (`codigoAvaliacaoTipo` ASC);
CREATE UNIQUE INDEX `avaliacao_unq` USING BTREE ON `Avaliacoes` (`codigoNoticia` ASC, `codigoAvaliacaoTipo` ASC);

-- -----------------------------------------------------
-- Table `ClientesMidias_x_ClientesAssuntos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClientesMidias_x_ClientesAssuntos` (
  `codigoClienteMidia` INT NOT NULL,
  `codigoClienteAssunto` INT NOT NULL,
  PRIMARY KEY (`codigoClienteMidia`, `codigoClienteAssunto`),
  CONSTRAINT `clienteMidia_clienteAssunto_fk`
    FOREIGN KEY (`codigoClienteMidia`)
    REFERENCES `ClientesMidias` (`codigoClienteMidia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clienteMidia_clientePalavraChave_fk`
    FOREIGN KEY (`codigoClienteAssunto`)
    REFERENCES `Clientes_x_Assuntos` (`codigoClienteAssunto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre ClientesMidias e ClientesAssuntos.';

CREATE INDEX `clienteMidia_fk_idx` ON `ClientesMidias_x_ClientesAssuntos` (`codigoClienteMidia` ASC);
CREATE INDEX `clienteAssunto_idx` ON `ClientesMidias_x_ClientesAssuntos` (`codigoClienteAssunto` ASC);
CREATE UNIQUE INDEX `codigoClienteMidia_unq` ON `ClientesMidias_x_ClientesAssuntos` (`codigoClienteMidia` ASC, `codigoClienteAssunto` ASC);

-- -----------------------------------------------------
-- Table `Veiculos_x_ClientesAssuntos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Veiculos_x_ClientesAssuntos` (
  `codigoVeiculo` INT NOT NULL,
  `codigoClienteAssunto` INT NOT NULL,
  PRIMARY KEY (`codigoVeiculo`, `codigoClienteAssunto`),
  CONSTRAINT `veiculoClienteAssunto_veiculo_fk`
    FOREIGN KEY (`codigoVeiculo`)
    REFERENCES `Veiculos` (`codigoVeiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `veiculoClienteAssunto_clienteAssunto_fk`
    FOREIGN KEY (`codigoClienteAssunto`)
    REFERENCES `Clientes_x_Assuntos` (`codigoClienteAssunto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Veiculos e ClientesAssuntos.';

CREATE INDEX `veiculo_fk_idx` ON `Veiculos_x_ClientesAssuntos` (`codigoVeiculo` ASC);
CREATE INDEX `clienteAssunto_idx` ON `Veiculos_x_ClientesAssuntos` (`codigoClienteAssunto` ASC);

-- -----------------------------------------------------
-- Table `PalavrasIgnoradas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PalavrasIgnoradas` (
  `codigoPalavraIgnorada` INT NOT NULL AUTO_INCREMENT,
  `palavraIgnorada` VARCHAR(45) NOT NULL,
  `hashPalavraIgnorada` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`codigoPalavraIgnorada`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda todas as palavras que serão ignoradas na avaliação de uma notícia.';

CREATE INDEX `hashPalavraIgnorada_idx` ON `PalavrasIgnoradas` (`hashPalavraIgnorada` ASC);

-- -----------------------------------------------------
-- Table `Palavras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Palavras` (
  `codigoPalavra` INT NOT NULL AUTO_INCREMENT,
  `codigoAvaliacaoTipo` INT NOT NULL,
  `palavra` VARCHAR(45) NOT NULL,
  `hashPalavra` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`codigoPalavra`),
  CONSTRAINT `palavra_avaliacaoTipo_fk`
    FOREIGN KEY (`codigoAvaliacaoTipo`)
    REFERENCES `AvaliacoesTipos` (`codigoAvaliacaoTipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda as palavras e seus tipos de avaliações.';

CREATE INDEX `avaliacaoTipo_idx` ON `Palavras` (`codigoAvaliacaoTipo` ASC);
CREATE INDEX `hashPalavra_idx` ON `Palavras` (`hashPalavra` ASC);

-- -----------------------------------------------------
-- Table `UrlsConteudos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UrlsConteudos` (
  `codigoURLConteudo` INT NOT NULL AUTO_INCREMENT,
  `codigoURL` INT NOT NULL,
  `URLConteudo` BLOB NOT NULL,
  `hashURLConteudo` VARCHAR(32) NOT NULL,
  `quantidadeCaracteres` INT NOT NULL,
  PRIMARY KEY (`codigoURLConteudo`),
  CONSTRAINT `urlConteudo_url_fk`
    FOREIGN KEY (`codigoURL`)
    REFERENCES `Urls` (`codigoURL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda o conteúdo capturado das urls.';

CREATE INDEX `url_fk_idx` ON `UrlsConteudos` (`codigoURL` ASC);

-- -----------------------------------------------------
-- Table `HostsBloqueados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HostsBloqueados` (
  `codigoHostBloqueado` INT NOT NULL AUTO_INCREMENT,
  `hostBloqueado` VARCHAR(100) NOT NULL,
  `hashHostBloqueado` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`codigoHostBloqueado`))
ENGINE = InnoDB
COMMENT = 'Entidade que guarda os hosts bloqueados para inclusão e busca.';

CREATE INDEX `hashHostBloqueado` ON `HostsBloqueados` (`hashHostBloqueado` ASC);

-- -----------------------------------------------------
-- Table `Assuntos_x_PalavrasChave`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Assuntos_x_PalavrasChave` (
  `codigoAssunto` INT NOT NULL AUTO_INCREMENT,
  `codigoPalavraChave` INT NOT NULL,
  PRIMARY KEY (`codigoAssunto`, `codigoPalavraChave`),
  CONSTRAINT `assuntoPalavraChave_assunto_fk`
    FOREIGN KEY (`codigoAssunto`)
    REFERENCES `Assuntos` (`codigoAssunto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `assuntoPalavraChave_palavraChave_fk`
    FOREIGN KEY (`codigoPalavraChave`)
    REFERENCES `PalavrasChave` (`codigoPalavraChave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade relacional entre Assuntos e PalavrasChave.';

CREATE INDEX `assunto_fk_idx` ON `Assuntos_x_PalavrasChave` (`codigoAssunto` ASC);
CREATE INDEX `palavrasChave_fk_idx` ON `Assuntos_x_PalavrasChave` (`codigoPalavraChave` ASC);

-- -----------------------------------------------------
-- Table `NoticiasDestaques`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `NoticiasDestaques` (
  `codigoNoticia` INT NOT NULL AUTO_INCREMENT,
  `codigoCliente` INT NOT NULL,
  `dataDestaque` TIMESTAMP NOT NULL,
  CONSTRAINT `noticiaDestaque_noticia_fk`
    FOREIGN KEY (`codigoNoticia`)
    REFERENCES `Noticias` (`codigoNoticia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `noticiaDestaque_cliente_fk`
    FOREIGN KEY (`codigoCliente`)
    REFERENCES `Clientes` (`codigoCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Entidade que guarda a relação de destaque de uma notícia para um cliente.';

CREATE INDEX `noticia_idx` ON `NoticiasDestaques` (`codigoNoticia` ASC);
CREATE INDEX `cliente_idx` ON `NoticiasDestaques` (`codigoCliente` ASC);

-- -----------------------------------------------------
-- Placeholder table for view `view_ClientesAtivos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `view_ClientesAtivos` (`codigoCliente` INT, `codigoClienteTipo` INT, `nomeCliente` INT, `clienteAtivo` INT);

-- -----------------------------------------------------
-- Placeholder table for view `view_NoticiasArquivadas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `view_NoticiasArquivadas` (`codigoURL` INT, `codigoNoticia` INT, `codigoEditoria` INT, `tituloNoticia` INT, `dataPublicacao` INT, `codigoVeiculo` INT, `codigoURLTipo` INT, `codigoURLStatus` INT, `URL` INT, `hashURL` INT, `tentativasCaptura` INT);

-- -----------------------------------------------------
-- Placeholder table for view `view_NoticiasProcessadas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `view_NoticiasProcessadas` (`codigoURL` INT, `codigoNoticia` INT, `codigoEditoria` INT, `tituloNoticia` INT, `dataPublicacao` INT, `codigoVeiculo` INT, `codigoURLTipo` INT, `codigoURLStatus` INT, `URL` INT, `hashURL` INT, `tentativasCaptura` INT);

-- -----------------------------------------------------
-- View `view_ClientesAtivos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `view_ClientesAtivos`;
CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ClientesAtivos` AS select `Clientes`.`codigoCliente` AS `codigoCliente`,`Clientes`.`codigoClienteTipo` AS `codigoClienteTipo`,`Clientes`.`nomeCliente` AS `nomeCliente`,`Clientes`.`clienteAtivo` AS `clienteAtivo` from `Clientes` where (`Clientes`.`clienteAtivo` = 1);

-- -----------------------------------------------------
-- View `view_NoticiasArquivadas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `view_NoticiasArquivadas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_NoticiasArquivadas` AS select `Noticias`.`codigoURL` AS `codigoURL`,`Noticias`.`codigoNoticia` AS `codigoNoticia`,`Noticias`.`codigoEditoria` AS `codigoEditoria`,`Noticias`.`tituloNoticia` AS `tituloNoticia`,`Noticias`.`dataPublicacao` AS `dataPublicacao`,`Urls`.`codigoVeiculo` AS `codigoVeiculo`,`Urls`.`codigoURLTipo` AS `codigoURLTipo`,`Urls`.`codigoURLStatus` AS `codigoURLStatus`,`Urls`.`URL` AS `URL`,`Urls`.`hashURL` AS `hashURL`,`Urls`.`tentativasCaptura` AS `tentativasCaptura` from (`Noticias` join `Urls` on((`Noticias`.`codigoURL` = `Urls`.`codigoURL`))) where (`Urls`.`codigoURLStatus` = 4);

-- -----------------------------------------------------
-- View `view_NoticiasProcessadas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `view_NoticiasProcessadas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_NoticiasProcessadas` AS select `Noticias`.`codigoURL` AS `codigoURL`,`Noticias`.`codigoNoticia` AS `codigoNoticia`,`Noticias`.`codigoEditoria` AS `codigoEditoria`,`Noticias`.`tituloNoticia` AS `tituloNoticia`,`Noticias`.`dataPublicacao` AS `dataPublicacao`,`Urls`.`codigoVeiculo` AS `codigoVeiculo`,`Urls`.`codigoURLTipo` AS `codigoURLTipo`,`Urls`.`codigoURLStatus` AS `codigoURLStatus`,`Urls`.`URL` AS `URL`,`Urls`.`hashURL` AS `hashURL`,`Urls`.`tentativasCaptura` AS `tentativasCaptura` from (`Noticias` join `Urls` on((`Noticias`.`codigoURL` = `Urls`.`codigoURL`))) where (`Urls`.`codigoURLStatus` = 2);

-- -----------------------------------------------------
-- Data for table `UrlsTipos`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `UrlsTipos` (`codigoURLTipo`, `URLTipo`) VALUES (DEFAULT, 'Repositório de link');
INSERT INTO `UrlsTipos` (`codigoURLTipo`, `URLTipo`) VALUES (DEFAULT, 'Notícia');
INSERT INTO `UrlsTipos` (`codigoURLTipo`, `URLTipo`) VALUES (DEFAULT, 'Desconhecido');
COMMIT;

-- -----------------------------------------------------
-- Data for table `UrlsStatus`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `UrlsStatus` (`codigoURLStatus`, `URLStatus`) VALUES (DEFAULT, 'Processada');
INSERT INTO `UrlsStatus` (`codigoURLStatus`, `URLStatus`) VALUES (DEFAULT, 'Duplicada');
INSERT INTO `UrlsStatus` (`codigoURLStatus`, `URLStatus`) VALUES (DEFAULT, 'Em processamento');
COMMIT;


-- -----------------------------------------------------
-- Data for table `UsuariosPerfisCamposTipos`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `UsuariosPerfisCamposTipos` (`codigoCampoTipo`, `campoTipo`) VALUES (DEFAULT, 'String');
INSERT INTO `UsuariosPerfisCamposTipos` (`codigoCampoTipo`, `campoTipo`) VALUES (DEFAULT, 'Integer');
INSERT INTO `UsuariosPerfisCamposTipos` (`codigoCampoTipo`, `campoTipo`) VALUES (DEFAULT, 'Float');
INSERT INTO `UsuariosPerfisCamposTipos` (`codigoCampoTipo`, `campoTipo`) VALUES (DEFAULT, 'Timestamp');
COMMIT;


-- -----------------------------------------------------
-- Data for table `UsuariosPerfisCampos`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `UsuariosPerfisCampos` (`codigoPerfilCampo`, `codigoUsuarioPerfilCampoTipo`, `campoPerfil`, `valorPadrao`, `obrigatoriedade`) VALUES (DEFAULT, 1, 'Nome', NULL, 1);
INSERT INTO `UsuariosPerfisCampos` (`codigoPerfilCampo`, `codigoUsuarioPerfilCampoTipo`, `campoPerfil`, `valorPadrao`, `obrigatoriedade`) VALUES (DEFAULT, 2, 'CPF', NULL, 0);
INSERT INTO `UsuariosPerfisCampos` (`codigoPerfilCampo`, `codigoUsuarioPerfilCampoTipo`, `campoPerfil`, `valorPadrao`, `obrigatoriedade`) VALUES (DEFAULT, 2, 'RG', NULL, 0);
INSERT INTO `UsuariosPerfisCampos` (`codigoPerfilCampo`, `codigoUsuarioPerfilCampoTipo`, `campoPerfil`, `valorPadrao`, `obrigatoriedade`) VALUES (DEFAULT, DEFAULT, 'Data de Nascimento', NULL, 0);
INSERT INTO `UsuariosPerfisCampos` (`codigoPerfilCampo`, `codigoUsuarioPerfilCampoTipo`, `campoPerfil`, `valorPadrao`, `obrigatoriedade`) VALUES (DEFAULT, DEFAULT, 'Sexo', NULL, 1);
COMMIT;


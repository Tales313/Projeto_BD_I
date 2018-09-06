/*** criação do banco de dados ***/
create database clinica_BD 
GO
Use clinica_BD
GO

/*** Criação da tabela Especialidade ***/
create table Especialidade(
	idesp smallint identity not null,
	nome varchar(30) not null,
	salario smallmoney not null,
	constraint PK_especialidade primary key(idesp),
	constraint CK_especialidade_salario CHECK (salario >0)
)

/***Criação da tabela Medico ***/
create table Medico(
	matricula smallint identity not null,
	nome varchar(40) not null,
	rg int not null,
	cpf varchar(12) not null,
	sexo varchar(1) not null,
	estcivil varchar(1) not null,
	datanasc date not null,
	dataadm date not null,
	numcrm int not null,
	matrichefe smallint  null,
	idesp smallint not null,
	constraint PK_medico PRIMARY KEY (matricula),
	constraint AK_medico_rg UNIQUE (rg),
	constraint AK_medico_cpf UNIQUE (cpf),
	constraint CK_medico_cpf CHECK (cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	constraint CK_medico_sexo CHECK (UPPER(sexo) IN ('F','M')),
	constraint CK_medico_estcivil CHECK (UPPER(estcivil) LIKE '[SCDVO]'),
	constraint CK_medico_datanasc CHECK (DATEDIFF(YEAR,datanasc,GETDATE())>=18),
	constraint CK_medico_dataadm CHECK (dataadm <= GETDATE()),
	constraint AK_medico_numcrm UNIQUE(numcrm),
	constraint FK_medico_medicochefe FOREIGN KEY (matrichefe) REFERENCES Medico,
	constraint FK_medico_especialidade FOREIGN KEY (idesp) REFERENCES Especialidade
)

/***Criação da Tabela Atendente***/
create table Atendente(
	matricula smallint identity not null,
	nome varchar(40) not null,
	rg int not null,
	cpf varchar(12) not null,
	sexo varchar(1) not null,
	estcivil varchar(1) not null,
	datanasc date not null,
	dataadm date not null,
	salario smallmoney not null,
	constraint PK_atendente PRIMARY KEY (matricula),
	constraint AK_atendente_rg UNIQUE (rg),
	constraint AK_atendente_cpf UNIQUE (cpf),
	constraint CK_atendente_cpf CHECK (cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	constraint CK_atendente_sexo CHECK (UPPER(sexo) IN ('F','M')),
	constraint CK_atendente_estcivil CHECK (UPPER(estcivil) LIKE '[SCDVO]'),
	constraint CK_atendente_datanasc CHECK(DATEDIFF(YEAR, datanasc, GETDATE())>=18),
	constraint CK_atendente_dataadm CHECK (dataadm <= GETDATE()),
	constraint CK_atendente_salario CHECK (salario > 0)
)

/***Criação da tabela Pais ***/
create table Pais(
	idpais varchar(3) not null,
	nome varchar (15) not null,
	constraint PK_pais PRIMARY KEY (idpais),
	constraint AK_pais_nome UNIQUE (nome)
)

/***criação da tabela Cidade ***/
create table Cidade(
	idcidade smallint identity not null,
	nome varchar(30) not null,
	uf varchar(2) NULL,
	idpais varchar(3)  null DEFAULT 'BRA',
	constraint PK_cidade PRIMARY KEY (idcidade),
	constraint AK_cidade_nome_uf UNIQUE (nome, uf),
	constraint CK_cidade_uf CHECK(LEN(uf)=2),
	constraint FK_cidade_pais FOREIGN KEY (idpais) references pais
)

/*** Criação da tabela Paciente ***/
create table Paciente(
	idpaciente smallint identity not null,
	nome varchar(40) not null,
	cpf varchar(12) not null,
	rg int not null,
	email varchar(45) null,
	cep varchar(8) null,
	bairro varchar(20) not null,
	rua varchar(30) not null,
	sexo varchar(1) not null,
	estcivil varchar(1) not null,
	numcartao int not null,
	datanasc date not null,
	data_exp_cartao date not null,
	data_venc_cartao date not null,
	idreside smallint not null,
	idnatural smallint not null,
	constraint PK_paciente PRIMARY KEY (idpaciente),
	constraint AK_paciente_cpf UNIQUE (cpf),
	constraint AK_paciente_rg UNIQUE (rg),
	constraint CK_paciente_cpf CHECK (cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	constraint CK_paciente_cep CHECK (LEN(cep) = 8),
	constraint CK_paciente_sexo CHECK (UPPER(sexo) IN ('F','M')),
	constraint CK_paciente_estcivil CHECK (UPPER(estcivil) LIKE '[SCDVO]'),
	constraint AK_paciente_numcartao UNIQUE (numcartao),
	constraint FK_paciente_cidade1 FOREIGN KEY(idreside) references Cidade,
	constraint FK_paciente_cidade2 FOREIGN KEY (idnatural) references Cidade
)

/*** Criação da tabela Telefone ***/
create table Telefone(
	num varchar(12) not null,
	idpac smallint not null,
	constraint PK_telefone PRIMARY KEY (num, idpac),
	constraint FK_telefone_paciente FOREIGN KEY (idpac) references Paciente
)
/***Criação da tabela Dependente ***/
create table Dependente(
	iddep smallint identity not null,
	nome varchar(40) not null,
	datanasc date not null,
	idpac smallint not null,
	constraint PK_dependete PRIMARY KEY (iddep, idpac),
	constraint FK_dependente_paciente FOREIGN KEY (idpac) REFERENCES Paciente 
)

/*** Criação da tabela agendamento ***/
create table Agendamento(
	idagendamento smallint identity not null,
	data_agendamento date not null,
	data_consulta date not null,
	historico varchar(100) null,
	constraint PK_agendamento PRIMARY KEY (idagendamento),
)
/*** Criação da tabela Atendimento_Paciente ***/
create table atendimento_paciente(
	matriate smallint not null,
	idpac smallint not null,
	idage smallint not null,
	constraint PK_atendimento_paciente PRIMARY KEY (matriate, idpac, idage),
	constraint FK_atendimento_paciente_atendente FOREIGN KEY (matriate) REFERENCES Atendente,
	constraint FK_atendimento_paciente_paciente FOREIGN KEY (idpac) REFERENCES Paciente,
	constraint FK_atendimento_paciente_agendamento FOREIGN KEY (idage) REFERENCES Agendamento
)
/*** criação da tabela consulta ***/
create table consulta(
	matrimed smallint not null,
	idpac smallint not null,
	data_consulta date not null,
	constraint PK_consulta PRIMARY KEY (matrimed, idpac, data_consulta),
	constraint FK_consulta_medico FOREIGN KEY (matrimed) REFERENCES Medico,
	constraint FK_consulta_paciente FOREIGN KEY (idpac) REFERENCES Paciente
)

/*** Criação da tabela Exame ***/
create table Exame (
	idexame smallint identity not null,
	nome varchar(20) not null,
	constraint PK_exame PRIMARY KEY (idexame)
)

/*** Criação da tabela Solicitação_Exame ***/
create table solicitacao_exame(
	idexame smallint not null,
	matrimed smallint not null,
	idpac smallint not null,
	data_solicitacao date not null,
	constraint PK_solicitacao_exame PRIMARY KEY (idexame, idpac, matrimed, data_solicitacao),
	constraint FK_solicitacao_exame_exame FOREIGN KEY (idexame) REFERENCES Exame,
	constraint FK_solicitacao_exame_consulta FOREIGN KEY (matrimed, idpac, data_solicitacao) REFERENCES Consulta
)

SET DATEFORMAT 'DMY'

/*** Inserção de dados na tabela Especialidade ***/
INSERT INTO especialidade values ('Cardiologia','8000')
INSERT INTO especialidade values ('Urologia','7000')
INSERT INTO especialidade values ('Clinico Geral','5000')
INSERT INTO especialidade values ('Cirugia','8000')
INSERT INTO especialidade values ('Oftamologia','8000')
INSERT INTO especialidade values ('Ortopedia','7000')
INSERT INTO especialidade values ('Gastroenterologia','9000')

/*** Inserção de dados na tabela Médico ***/
INSERT INTO medico (nome, rg, cpf, sexo, estcivil, datanasc, dataadm, numcrm, idesp) values ('Socorro Paiva dos Santos','3217619','01745965869','F','D','12/06/1958','05/04/1988','354568','7')	
INSERT INTO medico values ('Gesoaldo Santos Mello','3945789','90525536929','M','C','12/10/1980','10/10/2005','608598','1','5')	
INSERT INTO medico values ('Maria Sophia de Andrade','6598752','10565898745','F','C','10/04/1990','05/02/2015','805478','1','3')
INSERT INTO medico values ('Kamila Albuquerque Simoes','5387689','10054858936','F','S','06/11/1986','24/04/2017','705458','1','1')
INSERT INTO medico values ('João Freire de Andrade','2218613','00114569869','M','D','08/04/1940','05/04/1988','254589','1','5')

/***Inserção de Dados na tabela Atendente ***/
INSERT INTO atendente values ('Isabel dos Anjos Simões','3547869','01658789632','F','S','25/12/1993','20/04/2015','1200')
INSERT INTO atendente values ('Simone Serafim dos Santos','3785963','01462585936','F','S','30/05/1994','20/08/2014','1200')
INSERT INTO atendente values ('Maria Luiza dos Anjos','3219632','01463525896','F','S','12/01/1993','24/04/2015','1200')
INSERT INTO atendente values ('Maria Jose da Silva','2845256','11523558969','F','C','06/10/1985','03/05/2008','1200')
INSERT INTO atendente values ('Sharlene Tereza dos Santos','3218617','01463527569','F','S','06/02/1993','13/08/2016','1200')

/*** Inserção de dados na tabela Pais ***/
INSERT INTO Pais VALUES ('ALE','Alemanha')
INSERT INTO Pais VALUES ('ARG','Argentina')
INSERT INTO Pais VALUES ('AUT','Austrália')
INSERT INTO Pais VALUES ('AUS','Áustria')
INSERT INTO Pais VALUES ('BEL','Bélgica')
INSERT INTO Pais VALUES ('BRA','Brasil')
INSERT INTO Pais VALUES ('CAN','Canadá')
INSERT INTO Pais VALUES ('CHL','Chile')
INSERT INTO Pais VALUES ('CHI','China')
INSERT INTO Pais VALUES ('DIN','Dinamarca')
INSERT INTO Pais VALUES ('ESC','Escócia')
INSERT INTO Pais VALUES ('ESP','Espanha')
INSERT INTO Pais VALUES ('EUA','Estados Unidos')
INSERT INTO Pais VALUES ('FIN','Finlândia')
INSERT INTO Pais VALUES ('FRA','França')
INSERT INTO Pais VALUES ('GRE','Grécia')
INSERT INTO Pais VALUES ('ING','Inglaterra')
INSERT INTO Pais VALUES ('IRL','Irlanda')
INSERT INTO Pais VALUES ('ITA','Itália')
INSERT INTO Pais VALUES ('MEX','México')
INSERT INTO Pais VALUES ('NOR','Noruega')
INSERT INTO Pais VALUES ('POL','Polônia')
INSERT INTO Pais VALUES ('POR','Portugal')
INSERT INTO Pais VALUES ('RUS','Rússia')
INSERT INTO Pais VALUES ('SUE','Suécia')
INSERT INTO Pais VALUES ('SUI','Suiça')
INSERT INTO Pais VALUES ('VEN','Venezuela')

/*** Inserção de dados na tabela Cidade ***/
INSERT INTO Cidade(nome, uf) VALUES ('Recife','PE');
INSERT INTO Cidade (nome, uf) VALUES ('Natal','RN');
INSERT INTO Cidade (nome, uf) VALUES ('Rio de Janeiro','RJ');
INSERT INTO Cidade (nome, uf) VALUES ('São Paulo','SP');
INSERT INTO Cidade (nome, uf) VALUES ('Curitiba','PR');
INSERT INTO Cidade (nome, uf) VALUES ('Florianópolis','SC');
INSERT INTO Cidade (nome, uf) VALUES ('João Pessoa','PB');
INSERT INTO Cidade (nome, uf) VALUES ('Campina Grande','PB');
INSERT INTO Cidade (nome, uf) VALUES ('Campinas','SP');
INSERT INTO Cidade (nome, uf) VALUES ('Brasília','DF');
INSERT INTO Cidade (nome, uf) VALUES ('Salvador','BA');
INSERT INTO Cidade (nome, uf) VALUES ('Petrópolis','RJ');
INSERT INTO Cidade VALUES ('Berlin',NULL,'ALE');
INSERT INTO Cidade VALUES ('México',NULL,'MEX');
INSERT INTO Cidade VALUES ('London',NULL,'ING');
INSERT INTO Cidade VALUES ('Lulea',NULL,'SUE');
INSERT INTO Cidade VALUES ('Strasbourg',NULL,'FRA');
INSERT INTO Cidade VALUES ('Madrid',NULL,'ESP');
INSERT INTO Cidade VALUES ('Marseille',NULL,'FRA');
INSERT INTO Cidade VALUES ('Buenos Aires',NULL,'ARG');
INSERT INTO Cidade VALUES ('München',NULL,'ALE');
INSERT INTO Cidade VALUES ('Torino',NULL,'ITA');
INSERT INTO Cidade VALUES ('Cabedelo','PB','BRA');
INSERT INTO Cidade VALUES ('Lisboa',NULL,'POR');
INSERT INTO Cidade VALUES ('Barcelona',NULL,'ESP');
INSERT INTO Cidade VALUES ('Caracas','DF','VEN');
INSERT INTO Cidade VALUES ('San Cristóbal','Tá','VEN');
INSERT INTO Cidade VALUES ('Elgin','OR','EUA');
INSERT INTO Cidade VALUES ('Cork','CO','ARG');
INSERT INTO Cidade VALUES ('HedgeEnd','La','ING');
INSERT INTO Cidade VALUES ('Brandenburg',NULL,'ALE');
INSERT INTO Cidade VALUES ('Vancouver',NULL,'CAN');
INSERT INTO Cidade VALUES ('Frankfurt',NULL,'ALE');
INSERT INTO Cidade VALUES ('San Francisco','CA','EUA');
INSERT INTO Cidade VALUES ('Carpina','PE','BRA');
INSERT INTO Cidade VALUES ('Mamanguape','PB','BRA');
INSERT INTO Cidade VALUES ('Santa Rita','PB','BRA');
INSERT INTO Cidade VALUES ('Mossoró','RN','BRA');
INSERT INTO Cidade VALUES ('Patos','PB','BRA');
INSERT INTO Cidade VALUES ('Guarabira','PB','BRA');
INSERT INTO Cidade VALUES ('Cabo','PE','BRA');
INSERT INTO Cidade VALUES ('Cowes','IW','ING');
INSERT INTO Cidade VALUES ('Parla','GE','GRE');

/*** Inserção de dados na tabela Paciente ***/
INSERT INTO paciente values ('Maria Jose da Silva','01163227458','3245623',NULL,'58085333','Cruz das Armas','Av.Cruz das Armas','F','D','20181','12/10/1950','15/05/2008','15/05/2018','7','7')
INSERT INTO paciente values ('Maria Conceição Soares','06585936998','3585963',NULL,NULL,'Cristo','R. Samuel Estevão','F','S','20182','03/12/1960','20/08/2013','20/08/2023','7','7')
INSERT INTO paciente values ('Ricardo Erick da Silva','01765812345','3961269',NULL,'58085000','Jaguaribe','R. João Machado','M','S','20183','08/01/2006','20/05/2017','20/05/2027','7','7')
INSERT INTO paciente values ('Erick Ryan da Silva','01765889636','3225123','erickryan20@gmail.com',NULL,'Santa Luizinha','R. sargento hernestro ','M','S','20184','03/12/1995','23/07/2017','23/07/2027','8','8')
INSERT INTO paciente values ('Neil John da Silva','01463225889','4523258','neiljohn@gmail.com',NULL,'Santa Isabel','R. conceição das dores','M','S','20185','05/07/1988','10/10/2016','10/10/2026','8','8')
INSERT INTO paciente values ('Roselene da Costa Silva','11165447899','2615456','Roselenesilva@gmail.com',NULL,'Bairro da Tijuca','R. Samuel dos santos','F','S','20186','11/05/1974','20/03/2017','20/03/2017','3','3')
INSERT INTO paciente values ('Roseane Quirino da Silva','11563227458','4568259','rosequirino@hotmail.com','58085333','Bancários','Av.Samuel Roza','F','S','20187','24/10/1983','04/10/2013','04/10/2023','7','7')
INSERT INTO paciente values ('Rosecleide da silva Venâncio','22345678959','2545678','rosecleide45@gmail.com','58085008','Cidade Verde','R.Cidade Campo de Santana','F','C','20188','20/01/1972','28/04/2017','28/04/2027','7','7')
INSERT INTO paciente values ('Jose Elias da Silva','22445678989','3025456',NULL,'58080008','Cidade Verde','R. Cidade Campo de Santana','M','C','20189','08/08/1978','01/04/2013','01/04/2023','7','8')
INSERT INTO paciente values ('Gabriela da Silva Venâncio','01463552889','3225456','gabisilva@gmail.com',NULL,'Bairro da Tijuca','R. Conceição das Neves','F','C','201810','11/08/1996','05/10/2017','05/10/2017','3','3')

/*** Inserção de dados na Tabela Telefone ***/
INSERT INTO telefone VALUES ('8398902-6035','1')
INSERT INTO telefone VALUES ('8399985-1389','1')
INSERT INTO telefone VALUES ('8398865-3525','2')
INSERT INTO telefone VALUES ('8399890-9898','2')
INSERT INTO telefone VALUES ('8398825-4528','3')
INSERT INTO telefone VALUES ('8398905-2555','4')
INSERT INTO telefone VALUES ('8399956-4547','4')
INSERT INTO telefone VALUES ('8398888-8558','5')
INSERT INTO telefone VALUES ('8399797-5859','5')
INSERT INTO telefone VALUES ('8398885-3505','6')
INSERT INTO telefone VALUES ('8399895-3525','7')
INSERT INTO telefone VALUES ('8398835-4748','8')
INSERT INTO telefone VALUES ('8399895-9598','8')
INSERT INTO telefone VALUES ('8398609-3536','9')
INSERT INTO telefone VALUES ('8399895-9693','9')
INSERT INTO telefone VALUES ('8398609-6968','10')
INSERT INTO telefone VALUES ('8399897-9793','10')

/*** Inserção na tabela Dependente ***/
INSERT INTO dependente values ('Ruan nascimento Dos Santos Silva','05/12/2008','1')
INSERT INTO dependente values ('Robson serafin Dos Santos Silva','07/11/2006','1')
INSERT INTO dependente values ('Maria Helena Soares','07/10/2007','2')
INSERT INTO dependente values ('Maria Rita Venancio','24/10/2005','6')
INSERT INTO dependente values ('Emilly Quirino Venancio','20/10/2002','7')
INSERT INTO dependente values ('John Oliver V. de Andrade','12/01/1993','8')
INSERT INTO dependente values ('Luiz Eduardo da Silva','05/10/2006','8')
INSERT INTO dependente values ('Christopher Venãncio de Sousa','06/08/2000','8')
INSERT INTO dependente values ('Ryan Venâncio Sousa','08/01/2017','10')

/*** Inserção na Tabela Agendamento ***/
/*2016*/
INSERT INTO Agendamento VALUES ('24/01/2016','25/01/2016','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('24/01/2016','26/01/2016','consulta marcada dois dias após o agendamento')
INSERT INTO Agendamento VALUES ('25/01/2016','26/01/2016','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('25/01/2016','27/01/2016','consulta marcada para dois dias após o agendamento')
INSERT INTO Agendamento VALUES ('02/02/2016','04/02/2016','consulta marcada para dois dias após o agendamento')
INSERT INTO Agendamento VALUES ('02/02/2016','03/02/2016','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('14/02/2016','16/02/2016','consulta marcada para dois diaa após o agendamento')

/*2017*/
INSERT INTO Agendamento VALUES ('12/01/2017','13/01/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('15/01/2017','17/01/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('24/01/2017','25/01/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('12/02/2017','13/02/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('14/02/2017','15/02/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('17/02/2017','18/02/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('12/03/2017','13/03/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('12/04/2017','13/04/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('15/04/2017','16/04/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('19/04/2017','20/04/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('20/04/2017','21/04/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('20/04/2017','21/04/2017','consulta marcada para um dia após o agendamento')
INSERT INTO Agendamento VALUES ('20/04/2017','21/04/2017','consulta marcada para um dia após o agendamento')

/*** Inserção na tabela Atendimento_paciente ***/
INSERT INTO atendimento_paciente values('1','5','1')
INSERT INTO atendimento_paciente values('2','7','2')
INSERT INTO atendimento_paciente values('1','2','3')
INSERT INTO atendimento_paciente values('1','3','4')
INSERT INTO atendimento_paciente values('1','5','5')
INSERT INTO atendimento_paciente values('4','9','6')
INSERT INTO atendimento_paciente values('5','10','7')
INSERT INTO atendimento_paciente values('2','3','8')
INSERT INTO atendimento_paciente values('1','9','9')
INSERT INTO atendimento_paciente values('2','4','10')
INSERT INTO atendimento_paciente values('3','7','11')
INSERT INTO atendimento_paciente values('3','8','12')
INSERT INTO atendimento_paciente values('4','1','13')
INSERT INTO atendimento_paciente values('2','6','14')
INSERT INTO atendimento_paciente values('1','4','15')
INSERT INTO atendimento_paciente values('3','9','16')
INSERT INTO atendimento_paciente values('1','5','17')
INSERT INTO atendimento_paciente values('3','2','18')
INSERT INTO atendimento_paciente values('4','8','19')
INSERT INTO atendimento_paciente values('2','10','20')

/*** Inserção de dados na tabela consulta ***/
INSERT INTO consulta VALUES ('1','5','25/01/2016')
INSERT INTO consulta VALUES ('2','7','26/01/2016')
INSERT INTO consulta VALUES ('1','2','26/01/2016')
INSERT INTO consulta VALUES ('5','3','27/01/2016')
INSERT INTO consulta VALUES ('2','5','04/02/2016')
INSERT INTO consulta VALUES ('4','9','03/02/2016')
INSERT INTO consulta VALUES ('1','10','16/02/2016')
INSERT INTO consulta VALUES ('3','3','13/01/2017')
INSERT INTO consulta VALUES ('2','9','17/01/2017')
INSERT INTO consulta VALUES ('2','4','25/01/2017')
INSERT INTO consulta VALUES ('4','7','13/02/2017')
INSERT INTO consulta VALUES ('1','8','15/02/2017')
INSERT INTO consulta VALUES ('3','1','18/02/2017')
INSERT INTO consulta VALUES ('5','6','13/03/2017')
INSERT INTO consulta VALUES ('4','4','13/04/2017')
INSERT INTO consulta VALUES ('2','9','16/04/2017')
INSERT INTO consulta VALUES ('5','5','20/04/2017')
INSERT INTO consulta VALUES ('1','2','21/04/2017')
INSERT INTO consulta VALUES ('1','8','21/04/2017')
INSERT INTO consulta VALUES ('4','10','21/04/2017')

/* Inserção na tabela Exame */
INSERT INTO exame values('URINA')
INSERT INTO exame values('FEZES')
INSERT INTO exame values('HEMOGRAMA')
INSERT INTO exame values('TRIGUICERÍDEOS')
INSERT INTO exame values('COLESTEROL')
INSERT INTO exame values('GLICEMIA')
INSERT INTO exame values('GLICOSE')
INSERT INTO exame values('CREATININA')


/*Inserção de dados na tabela solicitacao_Exame */ 

INSERT INTO solicitacao_exame values ('1','1','5','25/01/2016')
INSERT INTO solicitacao_exame values ('1','2','7','26/01/2016')
INSERT INTO solicitacao_exame values ('2','2','7','26/01/2016')
INSERT INTO solicitacao_exame values ('1','1','2','26/01/2016')
INSERT INTO solicitacao_exame values ('2','1','2','26/01/2016')
INSERT INTO solicitacao_exame values ('3','1','2','26/01/2016')
INSERT INTO solicitacao_exame values ('4','2','5','04/02/2016')
INSERT INTO solicitacao_exame values ('6','2','5','04/02/2016')
INSERT INTO solicitacao_exame values ('3','1','10','16/02/2016')
INSERT INTO solicitacao_exame values ('1','2','9','17/01/2017')
INSERT INTO solicitacao_exame values ('2','2','9','17/01/2017')
INSERT INTO solicitacao_exame values ('3','2','9','17/01/2017')
INSERT INTO solicitacao_exame values ('3','4','7','13/02/2017')
INSERT INTO solicitacao_exame values ('6','4','7','13/02/2017')
INSERT INTO solicitacao_exame values ('6','5','6','13/03/2017')
INSERT INTO solicitacao_exame values ('1','2','9','16/04/2017')
INSERT INTO solicitacao_exame values ('2','2','9','16/04/2017')
INSERT INTO solicitacao_exame values ('2','1','2','21/04/2017')
INSERT INTO solicitacao_exame values ('1','1','2','21/04/2017')
INSERT INTO solicitacao_exame values ('3','1','2','21/04/2017')
INSERT INTO solicitacao_exame values ('3','1','8','21/04/2017')
INSERT INTO solicitacao_exame values ('1','1','8','21/04/2017')


/*** atualizando os dados do salario da coluna clinico geral da tabela especialidade ***/
UPDATE especialidade
SET salario = '8000'
WHERE idesp = 3

/*** atualizando os dados do salario e do nome da coluna Cirugia da tabela especialidade ***/
UPDATE especialidade
SET nome = 'Cirugia Geral', salario ='12000'
where idesp = 4

/***Atualizando dados da coluna num da tabela telefone do paciente com id 9 ***/
UPDATE Telefone
set num = '8398609-3537'
where num = '8398609-3536' and idpac = 9

/***Atualizando dados da coluna cep, bairro e rua da tabela Paciente onde o idpaciente é igual 5 ***/
UPDATE Paciente
set cep = '58085000', bairro = 'Cruz das Armas', rua = 'AV. Cruz das Armas'
where idpaciente = 5

/*** Excluindo Dados DA TABELA CIDADE QUE SEJA DA VENEZUELA e da ARGENTINA ***/
delete from cidade
where idpais = 'VEN'

delete from cidade
where idpais = 'ARG'

/*** Excluindo VENEZUELA, FINLANDIA BELGICA, e ARGENTINA do registro de dados da tabela pais ***/
delete from pais
where idpais = 'VEN' 

delete from pais
where idpais = 'ARG'

delete from pais
where idpais = 'FIN'

delete from pais
where idpais = 'BEL'
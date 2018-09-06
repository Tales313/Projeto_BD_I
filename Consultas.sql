/*consultando os pacientes que são natural do Rio de Janeiro *//*consulta clausula IN */

select  pa.nome, ci.uf from cidade ci inner join paciente pa
on ci.idcidade = pa.idnatural
where ci.uf IN ('RJ')


/*listando a data da consulta, o nome do paciente e o nome do exame das consultas
que geraram exames diferentes de HEMOGRAMA e URINA */ /*clausula NOT IN */

select con.data_consulta, pa.nome[paciente], ex.nome[exame] from paciente pa inner join consulta con on pa.idpaciente = con.idpac
inner join solicitacao_exame sol on con.matrimed = sol.matrimed and con.idpac = sol.idpac
and con.data_consulta = sol.data_solicitacao inner join Exame ex on ex.idexame = sol.idexame 
where ex.nome not in ('URINA','HEMOGRAMA')

/*Listando o nome do paciente, o nome do médico e a data da consulta que esteja entre 01/01/2016 e 01/01 2017
ordenados pela data */
/*clausula BETWEEN  & ORDER BY*/
SELECT pa.nome[paciente], med.nome[medico], cons.data_consulta from paciente pa inner join
consulta cons on pa.idpaciente = cons.idpac inner join medico med on med.matricula = cons.matrimed
where cons.data_consulta between '01/01/2016' and '01/01/2017'
order by 3

/*Listando o nome do paciente, o nome do médico e a data da consulta que não esteja esteja entre 01/01/2016 e 01/01 2017
ordenados pela data */
/*clausula NOT BETWEEN & ORDER BY */

SELECT pa.nome[paciente], med.nome[medico], cons.data_consulta from paciente pa inner join
consulta cons on pa.idpaciente = cons.idpac inner join medico med on med.matricula = cons.matrimed
where cons.data_consulta not between '01/01/2016' and '01/01/2017'
order by 3

/*listando os paciente sem email */ /*clausula IS NULL */

select nome, email from paciente where email is null

/* listando os paciente que tenham o cep cadastrado */ /*clausula IS NOT NULL */
select nome, cep from paciente where cep is not null

/*listando os pacientes que tenham o email 'GMAIL' */ /*clausula LIKE */
select nome, email from paciente where email like '%gmail%'

/*listando os pacientes que não tenham o email 'HOTMAIL' */ /*clausula NOT LIKE */

select nome, email from paciente where email not like '%hotmail%'

/*listando a data da consulta e a quantidade de exames solicitados para as consultas que solicitaram 2
 ou mais  exames */
/*clausula COUNT , GROUP BY & HAVING */
select data_solicitacao[data_consulta], count(idexame)[qtd exames] from solicitacao_exame
group by data_solicitacao
having count(idexame) >=2

/* somando o salario de todos os atendentes da clinica */ /*clausula SUM*/
select sum(salario) from atendente

/*LISTANDO A MEDIA DE SALÁRIO DE TODOS OS MÉDICOS DA CLÍNICA*/ /*clausula AVG */
select AVG(esp.salario)[media de salario] from especialidade esp inner join medico med
on esp.idesp = med.idesp


/*listando a especialidade que menos ganha*/ 
/*CLAUSULA MIN & group by */
select min(salario) from especialidade

/*listando a especialidade que mais ganha*/ 
/*clausula MAX & GROUP BY */
select max(salario)[salario] from especialidade



/*consultando  o nome das especialidades e o nome dos medicos que exercem a especialidade
exibindo tambem a especialidade que não tenham médicos ordenados pelo nome da especialidade */ /*LEFT JOIN */
 
 select esp.nome[especialidade], med.nome[medico] from especialidade esp  left join medico med
 on med.idesp = esp.idesp
 order by 1


/*consultando o nome do paciente e o nome da cidade que o paciente nasceu exibindo tambem 
as cidades que não tenham pacientes naturais de lá*/ /*clausula RIGHT JOIN */

select pa.nome[paciente], ci.nome[cidade] from paciente pa right join cidade ci on ci.idcidade = pa.idnatural


/*consultando o nome do medico e o nome do exame solicitado de uma consulta mostrando tambem o nome dos medicos
que nunca solicitou exames assim como o nome dos exames que nunca foi solicitado*/
select  con.data_consulta, me.nome[medico], ex.nome[exame] from medico me 
full join consulta con on me.matricula = con.matrimed full join solicitacao_exame sol on con.data_consulta = 
sol.data_solicitacao and con.idpac = sol.idpac and sol.matrimed = con.matrimed full join exame ex on sol.idexame
= ex.idexame

select * from solicitacao_exame
/*Exibir o nome dos medicos que ganham acima da média do salários dos médicos *//*SUBCONSULTA*/

select me.nome from medico me inner join especialidade esp
on me.idesp = esp.idesp where esp.salario >( select avg(salario) from especialidade)

/*selecionando o nome dos exames e a quantidade de vezes que foi solicitado tal exame *//*SUBCONSULTA*/
select ex.nome, (
select count(idexame) from solicitacao_Exame sol where ex.idexame = sol.idexame) from
exame ex
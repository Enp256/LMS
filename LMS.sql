create table usuario(
	ID tinyint NOT NULL,
	login		varchar(50)	NOT NULL,
	senha		varchar(30)	NOT NULL, 
	dtExpiracao	date		NOT NULL	default	'01/01/1900',

	CONSTRAINT	pk_usuarioID	primary key	(ID),
	CONSTRAINT	uq_UsuarioLogin	unique		(login)
)
create table coordenador(
	ID			tinyint		NOT NULL,
	id_usuario	tinyint		NOT NULL,
	nome		varchar(35)	NOT NULL,
	email		varchar(60)	NOT NULL,
	celular		int			NOT NULL,

	CONSTRAINT	pk_IdCoordenador		primary key	(ID),
	CONSTRAINT	fk_CoordenadorUsuarioID			foreign key	(ID) references usuario (ID),
	CONSTRAINT	uq_CoordenadorEmail		unique		(email),
	CONSTRAINT	uq_CoordenadorCelular	unique		(celular)
	
)
create table aluno(
	ID			tinyint		NOT NULL,
	id_usuario	tinyint		NOT NULL,
	nome		varchar(35)	NOT NULL,
	email		varchar(60)	NOT NULL,
	celular		int			NOT NULL,
	RA			int			NOT NULL,
	foto		varchar(300),

	CONSTRAINT	pk_IdAluno		primary key	(ID),
	CONSTRAINT	fk_AlunoUsuarioID	foreign key	(ID)	references	usuario (ID),
	CONSTRAINT	uq_AlunoEmail	unique		(email),
	CONSTRAINT	uq_AlunoCelular	unique		(celular)
)
create table professor(
	ID			tinyint		NOT NULL,
	id_usuario	tinyint		NOT NULL,
	email		varchar(60)	NOT NULL,
	celular		int			NOT NULL,
	apelido		varchar(30)	NOT NULL,

	CONSTRAINT	pk_IdProfessor		primary key	(ID),
	CONSTRAINT	fk_ProfessorIdUsuario		foreign key	(ID)	references	usuario (ID),
	CONSTRAINT	uq_ProfessorEmail	unique		(email),
	CONSTRAINT	uq_ProfessorCelular	unique		(celular)
)
create table disciplina(
	ID							tinyint			NOT NULL,
	nome						varchar(35)		NOT NULL,
	data						datetime		NOT NULL	default		(getdate()),
	status						char(8)			NOT NULL	default		('aberta'),
	planoDeEnsino				varchar(600)	NOT NULL,
	cargaHoraria				tinyint			NOT NULL,
	competencias				varchar(100)	NOT NULL,
	habilidades					varchar(100)	NOT NULL,
	ementa						varchar(70)		NOT NULL,
	conteudoProgmatico			varchar(1000)	NOT NULL,
	bibliografiabasica			varchar(100)	NOT NULL,
	bibliografiaComplementar	varchar(150)	NOT NULL,
	percentualPratico			tinyint			NOT NULL,
	percentualTeorico			tinyint			NOT NULL,
	idCoordenador				tinyint			NOT NULL,

	CONSTRAINT	pk_IdDisciplina					primary key	(ID),
	CONSTRAINT	fk_DisciplinaIdCoordenador		foreign key	(ID)	references coordenador (ID),
	CONSTRAINT	uq_DisciplinaNome				unique		(nome),
	CONSTRAINT	ck_DisciplinaPercentualPratico	CHECK		(percentualPratico between 00 and 100),
	CONSTRAINT	ck_DisciplinaPercentualTeorico	CHECK		(percentualTeorico between 00 and 100),
	CONSTRAINT	ck_DisciplinaStatus				CHECK		(status in('aberta','fechada')),
	CONSTRAINT	ck_DisciplinaCargaHoraria		CHECK		(cargaHoraria in (40,80))	

)

create table curso(
	ID		tinyint		NOT NULL,
	nome	varchar(35)	NOT NULL,

	CONSTRAINT pk_IdCurso	primary key (ID),
	CONSTRAINT uq_CursoNome	unique		(nome)

)	
create table disciplinaOfertada(
	ID					tinyint			NOT NULL,
	idCoordenador		tinyint			NOT NULL,
	dtInicioMatricula	date			NULL,
	dtFimMatricula		date			NULL,
	idDisciplina		tinyint			NOT NULL,
	idCurso				tinyint			NOT NULL,
	ano					smallint		NOT NULL,
	semestre			tinyint			NOT NULL,
	turma				char(10)		NOT NULL,
	idProfessor			tinyint			NULL,
	metododlogia		varchar(300)	NULL,
	recursos			varchar(300)	NULL,
	criterioAvaliacao	varchar(300)	NULL,
	planoDeAulas		varchar(300)	NULL,

	CONSTRAINT pk_IdDisciplinaOfertada			primary key (ID),
	CONSTRAINT fk_DisciplinaOfertadaIdCoordenador					foreign key (ID) references coordenador	(ID),
	CONSTRAINT fk_DisciplinaOfertadaIdDisciplina					foreign key (ID) references disciplina	(ID),
	CONSTRAINT fk_DisciplinaOfertadaIdCurso						foreign key (ID) references curso	(ID),
	CONSTRAINT ck_DisciplinaOfertadaAno			CHECK	(ano between 1900 and 2100 ),
	CONSTRAINT ck_DisciplinaOfertadaSemestre	CHECK	(semestre in (1,2)),
	CONSTRAINT ck_DisciplinaOfertadaTurma		CHECK	(turma like '[A,Z]'),

)
create table solicitacaoMatricula(
	ID						tinyint			NOT NULL,
	idAluno					tinyint			NOT NULL,
	idDisciplinaOferatada	varchar(100)	NOT NULL,
	dtSolicitacao			date			NOT NULL	default	(getdate()),
	idCoorddenador			tinyint,
	status					char(11)		default 'Solicitada',

	CONSTRAINT	pk_IdSolicitacaoMatricula		primary key	(ID),
	CONSTRAINT	fk_SolicitacaoMatriculaIdcoordenador				foreign key	(ID)references coordenador (ID),
	CONSTRAINT	fk_SolicitacaoMatriculaIdDisciplinaOferatada		foreign key	(ID)references disciplinaOfertada (ID),
	CONSTRAINT	fk_SolicitacaoMatriculaID_aluno						foreign key	(ID)references aluno (ID),
	CONSTRAINT	ck_SolicitacaoMatriculaStatus	CHECK		(status IN ('solicitada', 'cancelada', 'rejeitada', 'aprovada')),
	
)
create table atividade(
	ID			tinyint			NOT NULL,
	titulo		varchar(30)		NOT NULL,
	descricao	varchar(300)	NULL,
	conteudo	varchar(8000)	NOT NULL,
	tipo		char(16)		NOT NULL,
	extras		varchar(200)	NULL,
	idProfessor	tinyint			NOT NULL

	CONSTRAINT	pk_IdAtividade		primary key	(ID),
	CONSTRAINT	uq_AtividadeTitulo			unique		(titulo),
	CONSTRAINT	ck_AtividadeTipo				CHECK		(tipo IN ('Resposta aberta','Teste')),
	CONSTRAINT	fk_AtividadeIdProfessor		foreign key	(ID) references professor(ID),
	
)
create table atividadeVinculada(
	ID						tinyint			NOT NULL,
	idAtividade				tinyint			NOT NULL,
	idProfessor				tinyint			NOT NULL,
	idDisciplinaOfertada	tinyint			NOT NULL,
	rotulo					varchar(500)	NOT NULL,
	status					char(20)		NOT NULL,
	dtIniciorespostas		date			NOT NULL,
	dtFimRespostas			date			NOT NULL,

	CONSTRAINT	pk_IdAtividadeVinculada						primary key	(ID),
	CONSTRAINT	fk_AtividadeVinculadaIdAtividade			foreign key	(ID)			references atividade(ID),
	CONSTRAINT	fk_AtividadeVinculadaProfessor				foreign key (idProfessor)	references professor(ID),
	CONSTRAINT	fk_AtividadeVinculadaIdDisciplinaOferatada	foreign key	(ID)			references disciplinaOfertada (ID),
	CONSTRAINT	uq_Ativ_Rot_DiscOf							unique		(rotulo,idAtividade,idDisciplinaOfertada),
	CONSTRAINT	ck_AtividadeVinculadaStatus					check		(status in ('Disponibilizada','Aberta','Fechada','Encerrada','Prorrogada'))

)
create table entrega(
	ID						tinyint			NOT NULL,
	idAluno					tinyint			NOT NULL,
	idAtividadeVinculada	tinyint			NOT NULL,
	titulo					varchar(100)	NOT NULL,
	resposta				varchar(600)	NOT NULL,
	dtEntrega				datetime		NOT NULL default getdate(),
	status					char(15)		NOT NULL default 'Entregue',
	idProfessor				tinyint			NULL,
	nota					decimal(4,2)	NULL,
	dtAvaliacao				date			NULL,
	obs						varchar(800)	NULL,

	CONSTRAINT	pk_IdEntrega			primary key(ID),
	CONSTRAINT	fk_EntregaIdAluno				foreign key(ID) references aluno(ID),
	CONSTRAINT	fk_EntregaIdAtividadeVinculada	foreign key(ID) references atividadeVinculada(ID),
	CONSTRAINT	ck_EntregaStatus				CHECK(Status LIKE 'Corrigido' or Status LIKE 'Entregue'),
	CONSTRAINT	fk_EntregaIdProfessor			foreign key(ID) references professor(ID),
	CONSTRAINT	ck_EntregaNota					CHECK (nota between 0.00 and 10.00),

)
create table mensagem(
	ID			tinyint			NOT NULL,
	idAluno		tinyint			NOT NULL,
	idProfessor	tinyint			NOT NULL,
	assunto		varchar(255)	NOT NULL,
	referencia	varchar(255)	NOT NULL,
	conteudo	varchar(255)	NOT NULL,
	status		char(15)		NOT NULL DEFAULT 'Enviado',
	dtEnvio		date			NOT NULL DEFAULT getdate(),
	dtResposta	date			NULL,
	resposta	varchar(400)	NULL,

	CONSTRAINT pk_IdMensagem	primary key (ID),
	CONSTRAINT fk_MensagemAluno			foreign key (idAluno)		REFERENCES aluno(ID),
	CONSTRAINT fk_MensagemProfessor		foreign key (idProfessor)	REFERENCES professor(ID),
	CONSTRAINT ck_MensagemStatus		CHECK (Status IN ('Enviado','Lido','Respondido'))

)

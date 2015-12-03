Mario Kart - OpenGL + GLUT
==============

**Txai Wieser - 00217052**

*Fundamentos de Computação Gráfica - UFRGS*

*Dezembro/2015*

![ss 1](https://github.com/txaidw/MarioKart_OpenGL/blob/master/ss/ss1.png)

Descrição:
--------------

GLUT (OpenGL Utility Toolkit) é uma biblioteca para OpenGL cujo principal objetivo é a abstração de conceitos na comunicação do OpenGL com o sistema operacional, como por exemplo o gerenciamento de janelas e tratamento de eventos de dispositivos de entrada.

Para a criação do jogo Mario Kart, resolvi por criar uma estrutura de engine básica para depois desenvolver o jogo em cima, assim o trabalho maior estaria em criar essa mini-engine lidando com OpenGL diretamente e depois o jogo em sí poderia ser trabalhado mais facilmente.

* Objective-C & Objective-C++ & C++ & C *
A linguagem escolhida para a realização do trabalho foi uma variação do Objective-C chamada de Objective-C++. Assim é possível utilizar em um mesmo programa as linguagens C, C++ e Objective-C. Portando o projeto deve ser aberto e compilado através da IDE Xcode.

![ss 2](https://github.com/txaidw/MarioKart_OpenGL/blob/master/ss/ss2.png)

Além dos frameworks OpenGL e GLUT foi utilizado uma pequena biblioteca para leitura dos arquivos modelos .OBJ e as texturas .TGA, chama GLM.
As classes dessa engine possuem o prefixo (TWGL). As classes criadas foram TWGLNode, TWGLScene e TWGLCamera.
A classe mais importante é a TWGLNode, sendo herdada tanto na TWGLScene como na TWGLCamera.
Algumas das principais propriedades e métodos:

```Objective-C
@property GLfloat scale;
@property Vector3 position
@property Vector3 rotation;

@property (weak) TWGLNode *parent;
@property (weak) TWGLNode *scene;
@property GLMmodel *model;

@property (nonatomic, copy) void (^action)(TWGLNode *node, GLfloat dt);

- (void)render;
- (void)updateWithDelta:(NSTimeInterval)dt;

- (void)addChild:(TWGLNode *)node;
- (void)removeChild:(TWGLNode *)node;
- (void)removeFromParent;

- (void)calculateAbsolutePosition:(GLfloat *)xx yy:(GLfloat *)yy zz:(GLfloat *)zz;
- (void)calculateAbsoluteRotation:(GLfloat *)xx yy:(GLfloat *)yy zz:(GLfloat *)zz;

- (void)collisionCheck;
- (void)didCollideWith:(TWGLNode *)node;

- (GLfloat)distanceToNode:(TWGLNode *)node;
- (GLfloat)distanceToPointX:(float)nx y:(float)ny z:(float)nz;
```

O método render() toma conta de criar um espaço especifico para o nodo e renderiza o model atrelado ao nodo na cena. A funcionalidade dos outros métodos e propriedades podem ser inferidas pelos seus nomes ou visualizando o código fonte.
O maior ganho em utilizar o padrão de nodos na cena herdando de uma mesma classe é que diversos métodos podem ser compartilhados, como a renderização, o posicionamento e a colisão.

## Controles ##
Para controlar o carro principal basta utilizar os seguintes comandos:
* Tecla W: (ou seta para cima): acelerar o kart para a frente; 
* Tecla S: (ou seta para baixo): frear o kart e acelerar para trás quando parado; 
* Tecla A: (ou seta para esquerda): vira o kart para esquerda; 
* Tecla D: (ou seta para direita): vira o kart para direita; 
* Barra de espaço: utiliza o item armazenado; 
* Tecla V: alterna entre os diferentes tipos de câmera. 

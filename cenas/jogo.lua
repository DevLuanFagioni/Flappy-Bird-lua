local composer = require('composer')

local cena = composer.newScene()

function cena:create( event )
  local cenaJogo = self.view

  --DECLARACAO DAS VARIAVEIS x e y
  local x = display.contentWidth
  local y = display.contentHeight

  -- DECLARACAO DOS GRUPOS
  local grupoFundo = display.newGroup()
  local grupoJogo = display.newGroup()
  local grupoGUI = display.newGroup()
  cenaJogo:insert(grupoFundo)
  cenaJogo:insert(grupoJogo)
  cenaJogo:insert(grupoGUI)

  -- DECLARACAO DA FISICA
  local physics = require('physics')
  physics.start()
  physics.setGravity( 0, 80 )
  physics.setDrawMode( 'normal' )

  -- DECLARACAO DAS VARIAVEIS
  local vivo = true
  local pontos = 0
  local fonte = 'recursos/fontes/font.ttf'


  -- DECLARACA0 DAS IMAGENS
  local imagens = {
    fundo = {
      'recursos/imagens/background-day.png',
      'recursos/imagens/background-night.png'
    },
    canos = {
      'recursos/imagens/pipe-green.png',
      'recursos/imagens/pipe-red.png'
    }
  }

  -- DECLARACAO DA RANDOMIZACAO
  local fundoRandomico = math.random(1, 2)
  local canoRandomico = math.random(1, 2)

  -- DECLARACAO DOS OBJETOS
  local fundo = display.newImageRect(grupoFundo, imagens.fundo[fundoRandomico], x, y )
  fundo.x = x*0.5
  fundo.y = y*0.5

  local chao = display.newImageRect(grupoJogo, 'recursos/imagens/base.png', x, y*0.25 )
  chao.x = x*0.5
  chao.y = y*0.9
  physics.addBody( chao, 'static', {bounce = 0} )
  chao.id = 'obstaculo'

  local spriteSheet = graphics.newImageSheet( 'recursos/imagens/bird-sprite-sheet.png', {
    width = 800/4,
    height = 270/2,
    numFrames = 8,
    sheetContentWidth = 800,
    sheetContentHeight = 270
  } ) 

  local sequencia = {
    {name = 'voando', start = 1, count = 8, time = 800, countLoop = 0 },
    {name = 'parado', start = 1, count = 1, time = 0, countLoop = 0 }
  }

  local jogador = display.newSprite( spriteSheet, sequencia )
  jogador.x = x*0.3
  jogador.y = y*0.15
  physics.addBody( jogador, 'dynamic', {radius = 60, bounce = 0} )
  jogador.id = 'jogadorID'
  jogador:play() 

  local textoPontos = display.newText(grupoGUI, pontos, x*0.5, y*0.1, fonte, 200 )

  -- DECLARACAO DAS FUNCIONALIDADES
  function voar( event )
    if event.phase == 'began' and vivo == true then
      audio.play( audioVoar )
      jogador:setLinearVelocity( 0, -1000)
    end
  end
  Runtime:addEventListener('touch', voar)


  function addCanos()
    if vivo == true then

      local canoBaixo = display.newImageRect(grupoJogo, imagens.canos[canoRandomico], x*0.2, y*0.8  )
      canoBaixo.x = x*1.2
      canoBaixo.y = math.random( y*0.65, y*1.05 )
      physics.addBody( canoBaixo, 'static' )
      canoBaixo.id = 'obstaculo'

      transition.to(canoBaixo, {
        time = 3500,
        x = -x*0.2,
        onComplete = function()
          display.remove( canoBaixo )
        end
      })

      local canoCima = display.newImageRect(grupoJogo, imagens.canos[canoRandomico], x*0.2, y*0.8  )
      canoCima.x = canoBaixo.x
      canoCima.y = canoBaixo.y - canoBaixo.height*1.2
      canoCima.rotation = 180
      physics.addBody( canoCima, 'static' )
      canoCima.id = 'obstaculo'

      transition.to(canoCima, {
        time = 3500,
        x = -x*0.2,
        onComplete = function()
          display.remove( canoCima )
        end
      })

      local sensor = display.newRect(grupoJogo, canoBaixo.x, canoBaixo.y - canoBaixo.height*0.6, 40, 450 )
      physics.addBody( sensor, 'static' )
      sensor.id = 'sensorID'
      sensor.alpha = 0
      sensor.isSensor = true

      transition.to(sensor, {
        time = 3500,
        x = -x*0.2,
        onComplete = function()
          display.remove( sensor )
        end
      })


    end
  end
  timer.performWithDelay( 2000, addCanos, 0 )


  function verificaColisao( event )
    if event.phase == 'began' and vivo == true then
      
      local objeto1 = event.object1
      local objeto2 = event.object2

      if (objeto1.id == 'jogadorID' and objeto2.id == 'sensorID') or (objeto2.id == 'jogadorID' and objeto1.id == 'sensorID') then
        
        audio.play( audioPonto )
        pontos = pontos + 1
        textoPontos.text = pontos
      end

      if (objeto1.id == 'jogadorID' and objeto2.id == 'obstaculo') or (objeto2.id == 'jogadorID' and objeto1.id == 'obstaculo') then
        
        jogador:setSequence('parado')
        jogador:play()
        audio.play( audioMorte )
        vivo = false

        local gameOver = display.newImageRect(grupoGUI, 'recursos/imagens/gameover.png', x*0.8, y*0.15)
        gameOver.x = x*0.5
        gameOver.y = y*0.5

        function removeCena()
          composer.removeScene( 'cenas.jogo' )
        end

        timer.performWithDelay( 4000, function()
          removeCena()
          display.remove( jogador )
          display.remove( canoCima )
          display.remove( canoBaixo )
          display.remove( sensor )
          composer.gotoScene( 'cenas.inicio', {
            effect = 'slideRight', time = 500
          } )
        end , 1 )


      end

   
    end
  end
  Runtime:addEventListener('collision', verificaColisao)




end
cena:addEventListener('create', cena)
return cena
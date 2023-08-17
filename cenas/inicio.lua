local composer = require('composer')

local cena = composer.newScene()

function cena:create( event )
  local cenaInicio = self.view

  local x = display.contentWidth
  local y = display.contentHeight

  local audioMusica = audio.loadStream('recursos/audio/music.mp3')

  audio.play( audioMusica, {channel = 32, loops = 0} )
  audio.setVolume( 0.3 , {channel = 32} )

  local fundo = display.newImageRect(cenaInicio, 'recursos/imagens/background-day.png', x, y )
  fundo.x = x*0.5
  fundo.y = y*0.5

  local chao = display.newImageRect(cenaInicio, 'recursos/imagens/base.png', x, y*0.25 )
  chao.x = x*0.5
  chao.y = y*0.9

  local iniciar = display.newImageRect(cenaInicio, 'recursos/imagens/start.png', x*0.8, y*0.8)
  iniciar.x = x*0.5
  iniciar.y = y*0.5

  function iniciarJogo( event )
    if event.phase == 'began' then
      composer.gotoScene( 'cenas.jogo', {
        time = 500, effect = 'slideLeft'
      })
      audio.play( audioTransicao )
    end
  end
  iniciar:addEventListener('touch', iniciarJogo)





end
cena:addEventListener('create', cena)
return cena
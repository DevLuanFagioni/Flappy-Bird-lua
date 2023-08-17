
local composer = require('composer')

-- CENA QUE O PROJETO IRA INICIAR
composer.gotoScene( 'cenas.inicio' )

-- REMOVE A BARRA DE STATUS
display.setStatusBar( display.HiddenStatusBar )

-- VARIAVEIS GLOBAIS
audioMorte = audio.loadSound('recursos/audio/die.mp3')

audioPonto = audio.loadSound('recursos/audio/point.mp3')

audioTransicao = audio.loadSound('recursos/audio/wing.mp3')

audioVoar = audio.loadSound('recursos/audio/swoosh.mp3')

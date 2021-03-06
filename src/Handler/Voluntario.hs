{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Voluntario where

import Import
import Database.Persist.Postgresql

getVoluntarioR :: Handler Value
getVoluntarioR = do
    todosVoluntarios <- runDB $ selectList [] [Asc VoluntarioNome]
    sendStatusJSON ok200 (object ["resp" .= todosVoluntarios])

postVoluntarioR :: Handler Value
postVoluntarioR = do
    voluntario <- requireJsonBody :: Handler Voluntario
    vid <- runDB $ insert voluntario
    sendStatusJSON created201 (object ["resp" .= fromSqlKey vid])
    
getVoluntarioIdR :: VoluntarioId -> Handler Value
getVoluntarioIdR vid = do 
    volunt <- runDB $ get404 vid
    sendStatusJSON ok200 (object ["resp" .= volunt])

putVoluntarioIdR :: VoluntarioId -> Handler Value
putVoluntarioIdR vid = do
    _ <- runDB $ get404 vid
    novoVoluntario <- requireJsonBody :: Handler Voluntario
    runDB $ replace vid novoVoluntario
    sendStatusJSON noContent204 (object [])

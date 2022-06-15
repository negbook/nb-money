## exports server
```
exports["nb-money"]:RemovePlayerMoney(player,accountType,amount,cb,reason,safe)
exports["nb-money"]:AddPlayerMoney(player,accountType,amount,cb,reason,safe)
exports["nb-money"]:TransferPlayerMoney(player,cb,amount,accountTypeFrom,accountTypeTo,outreason,inreason)
exports["nb-money"]:TransferPlayerMoneyToPlayer(player,targetplayer,cb,amount,typeFrom,typeTo,outreason,inreason)
```
## events server (not supported TriggerServerEvent for safe)
```
TriggerEvent("RemovePlayerMoney",player,accountType,amount,cb,reason,safe)
TriggerEvent("AddPlayerMoney",player,accountType,amount,cb,reason,safe)
TriggerEvent("TransferPlayerMoney",player,cb,amount,accountTypeFrom,accountTypeTo,outreason,inreason)
TriggerEvent("TransferPlayerMoneyToPlayer",player,targetplayer,cb,amount,typeFrom,typeTo,outreason,inreason)
```


## exports client 
```
exports["nb-money"]:ChargerMoney(accountType,amount,cb,reason)
```

## event client 
```
TriggerEvent("ChargerMoney",accountType,amount,cb,reason)
```

## configs 
```
config.acceptedtable    to set what your money type exactly is in sql to avoid sql-injection
config.displayMPMoney   to display MP Money on the screenRightTop
config.fadeoutTimerMS   to set display off timer of MP Money  (less than or equal 0 = forever)
config.startingCash     to set starting cash if some new guy come
config.startingBank     to set starting bank if some new guy come
config.startingCryto    to set starting cryto if some new guy come
config.salary           to set using salary system
config.salaryAmount     to set salary amount to the bank 
config.salaryIntervalMS   to set salary timer MS 
config.disableEvents    to disable events from this script and use only with exports 
```

## commands 
```
/givecash cashAmount serverid (if serverid is empty will get closest player as possible)
/paybank bankAmount serverid (if serverid is empty will get closest player as possible)
/rconpaybank bankAmount serverid (rcon adding a player bank)
```

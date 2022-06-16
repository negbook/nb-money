## import functions
put this in yoru fxmanifest.lua to use those functions, also recommended dependencies it
```
shared_scripts{
    '@nb-money/import.lua'
}

dependencies {
    'nb-money',
    ...
}

```

## server functions
```
RemovePlayerMoney(player,accountType,amount,cb,reason,safe)
AddPlayerMoney(player,accountType,amount,cb,reason,safe)
TransferPlayerMoney(player,cb,amount,accountTypeFrom,accountTypeTo,outreason,inreason)
TransferPlayerMoneyToPlayer(player,targetplayer,cb,amount,typeFrom,typeTo,outreason,inreason)
GetMoneyLog(player,cb)
GetPlayerMoney(player,cb)

```

## client functions
```
ChargerMoney(accountType,amount,cb,reason)
UpdatePlayerMpMoneyUI(cash,bank)
MoneyTransfedMessage(...)
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
```

## commands 
```
/givecash cashAmount serverid (if serverid is empty will get closest player as possible)
/paybank bankAmount serverid (if serverid is empty will get closest player as possible)
/rconpaybank bankAmount serverid (rcon adding a player bank)
```

GameEvents.Subscribe("show_mkb_upgrade", function(){

    GameEvents.SendCustomGameEventToServer("upgrade_mkb", {});

});
function CheckMKBUpgrade(hero)

    local count = 0

    for slot = 0, 5 do
        local item = hero:GetItemInSlot(slot)

        if item and item:GetName() == "item_monkey_king_bar" then
            count = count + 1
        end
    end

    if count >= 2 then

        hero:RemoveItemByName("item_monkey_king_bar")
        hero:RemoveItemByName("item_monkey_king_bar")

        hero:AddItemByName("item_mkb_2")

    end
end
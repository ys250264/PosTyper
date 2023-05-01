use LoyaltyOnline_Unicoop1_1
update CRM_OL_BuyingUnitData set LockDateTime = null
where BuyingUnitInternalKey = (select BuyingUnitInternalKey from CRM_ClubCard where ClubCardId='0210128865119')
----- (1) Выборка ----
/*Запускаем чтобы проверить количество обновляемых сделок, для этого меняем d.DATE_CREATE в самом конце*/*/
/* Если не сильно много <100 тыс то можно обновляться за эти даты*/
/*ПОСЛЕДНИЕЕ ОБНОВЛЕНИЕ = до '2020-05-31 23:59'*/


select
d.ID,
ud.UF_LINK_TO_QUOTE,
ROUND(p.PROPERTY_1974)

from
	b_crm_deal as d
		join b_uts_crm_deal as ud
			on d.ID = ud.VALUE_ID
		join b_crm_product_row as row
			on row.OWNER_ID = d.ID
		JOIN b_iblock_element as ib
			on ib.id = row.PRODUCT_ID
		JOIN b_iblock_element_prop_s21 as p
			on p.IBLOCK_ELEMENT_ID = row.PRODUCT_ID

where 
row.OWNER_TYPE = 'D'
--and 
--d.ID = 3401617
and
ib.IBLOCK_SECTION_ID in ('2335', '7010', '7370', '2408')
and
ud.UF_LINK_TO_QUOTE is NULL
and 
d.DATE_CREATE BETWEEN '2020-06-01 00:00' and '2020-06-30 23:59'


------- (2) Апдейтим с сохранением даты изменения---

UPDATE
b_crm_deal as d
		join b_uts_crm_deal as ud
			on d.ID = ud.VALUE_ID
		join b_crm_product_row as row
			on row.OWNER_ID = d.ID
		JOIN b_iblock_element as ib
			on ib.id = row.PRODUCT_ID
		JOIN b_iblock_element_prop_s21 as p
			on p.IBLOCK_ELEMENT_ID = row.PRODUCT_ID

SET
ud.UF_LINK_TO_QUOTE = ROUND(p.PROPERTY_1974),
ud.UF_CRM_STAT_OTHER = d.DATE_MODIFY,
d.DATE_MODIFY = '2020-09-22 09:00', /* ЗДЕСЬ ПИШЕМ ТЕКУЩУЮ ДАТУ И ВРЕМЯ ОБНОВЛЕНИЯ */
d.MODIFY_BY_ID = '1',
ud.UF_CRM_ID_SD = 'deal_quote_modify'

where 
row.OWNER_TYPE = 'D'
and
ib.IBLOCK_SECTION_ID in ('2335', '7010', '7370', '2408')
and
ud.UF_LINK_TO_QUOTE is NULL
and 
d.DATE_CREATE BETWEEN '2020-06-01 00:00' and '2020-06-30 23:59' /* ДАТА ПОИСКА СДЕЛОК ИЗ ПРОШЛОГО ЗАПРОСА */
--and d.ID IN ( 987351,	987350 )




------ (3) Проверяем UPDATE ---------
/*Тут проверяем везде ли всё проставилось*/*/

select
d.ID as 'ID',
ud.UF_LINK_TO_QUOTE as 'ID Предложения',
ROUND(p.PROPERTY_1974) as 'Предложение из товара',
d.DATE_MODIFY as 'Дата изменения',
ud.UF_CRM_STAT_OTHER

from
	b_crm_deal as d
		join b_uts_crm_deal as ud
			on d.ID = ud.VALUE_ID
		join b_crm_product_row as row
			on row.OWNER_ID = d.ID
		JOIN b_iblock_element as ib
			on ib.id = row.PRODUCT_ID
		JOIN b_iblock_element_prop_s21 as p
			on p.IBLOCK_ELEMENT_ID = row.PRODUCT_ID

where 
ud.UF_CRM_ID_SD = 'deal_quote_modify' 
and
d.DATE_CREATE BETWEEN '2020-06-01 00:00' and '2020-06-30 23:59'
--and
--ud.UF_LINK_TO_QUOTE is null







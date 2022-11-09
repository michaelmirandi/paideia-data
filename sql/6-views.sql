drop view vw_daos;
drop view vw_activity_log;

CREATE VIEW vw_daos AS (
    SELECT
        D.id,
        D.dao_name,
        D.dao_url,
        D.dao_short_description,
        DD.logo_url,
        T.token_id,
        T.token_ticker,
        COUNT(DISTINCT UD.id) AS member_count,
        COUNT(DISTINCT P.id) AS proposal_count

    FROM daos D
    INNER JOIN tokenomics T ON T.dao_id = D.id
    INNER JOIN dao_designs DD ON DD.dao_id = D.id
    LEFT JOIN user_details UD ON UD.dao_id = D.id
    LEFT JOIN proposals P ON P.dao_id = D.id
    GROUP BY D.id, D.dao_name, D.dao_url, DD.logo_url, T.token_id, T.token_ticker
);

CREATE VIEW vw_activity_log AS (
    SELECT
        AL.id,
        AL.user_details_id,
        UD.name,
        UD.profile_img_url as img_url,
        AL.action,
        AL.value,
        AL.secondary_action,
        AL.secondary_value,
        date,
        category
    FROM
        activity_log AL
        INNER JOIN user_details UD ON UD.id = AL.user_details_id
);
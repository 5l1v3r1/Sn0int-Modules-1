-- Description: Query alienvault otx passive dns for subdomains of a domain
-- Version: 0.2.0
-- Source: domains
-- License: GPL-3.0

function run(arg)
    session = http_mksession()

    url = 'https://otx.alienvault.com/api/v1/indicators/domain/' .. arg['value'] .. '/passive_dns'

    req = http_request(session, 'GET', url, {})

    resp = http_send(req)
    if last_err() then return end
    if resp['status'] ~= 200 then return 'http error: ' .. resp['status'] end

    o = json_decode(resp['text'])
    if last_err() then return end
    o = o['passive_dns']

    i = 1
    while o[i] do
        x = o[i]

        db_add('subdomain', {
            domain_id=arg['id'],
            value=x['hostname'],
        })

        i = i+1
    end
end

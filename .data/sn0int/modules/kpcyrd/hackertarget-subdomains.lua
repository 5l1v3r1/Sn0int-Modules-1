-- Description: Query hackertarget for subdomains of a domain
-- Version: 0.1.0
-- Source: domains
-- License: GPL-3.0

function run(arg)
    session = http_mksession()

    req = http_request(session, 'GET', 'https://api.hackertarget.com/hostsearch/', {
        query={
            q=arg['value']
        }
    })

    resp = http_send(req)
    if last_err() then return end
    if resp['status'] ~= 200 then return 'http error: ' .. resp['status'] end

    m = regex_find_all("([^,]+),.+\\n?", resp['text'])

    i = 1
    while i <= #m do
        db_add('subdomain', {
            domain_id=arg['id'],
            value=m[i][2]
        })

        i = i+1
    end
end

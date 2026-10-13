Config = {
    Contract = 1,
    RequiredCoreContract = 1,
    RequiredEconomyContract = 1,
    DevMode = false,
    Access = {
        -- Resources allowed to register obligation types. Registration binds a
        -- type key to its first owner permanently; only that owner may issue,
        -- cancel, default, or resolve disputes for obligations of that type.
        trustedIssuers = {
            --['bcc-housing'] = true
        },
        -- Resources allowed to read any obligation (support and admin tooling).
        -- Type owners can always read obligations of their own types.
        trustedReaders = {
            ['feather-admin'] = true
        },
        -- Resources allowed to run settlement reconciliation on demand.
        trustedReconcilers = {
            ['feather-admin'] = true
        }
    },
    Authorization = {
        -- Service policy is evaluated through Core with the calling resource as
        -- subject.resource. With feather-admin as policy provider, each issuer
        -- needs explicit Config.servicePolicy['feather-contracts'][<resource>] grants.
        enabled = true,
        issueAction = 'contracts.obligation.issue',
        cancelAction = 'contracts.obligation.cancel',
        defaultAction = 'contracts.obligation.default'
    },
    Settlement = {
        reasonCode = 'contracts.settlement',
        referenceType = 'contract_obligation',
        -- Creditor party types accepted at issuance. Organization treasuries stay
        -- disabled until feather-economy permits contract settlement into them;
        -- Contracts refuses to issue an obligation it could never settle.
        creditorTypes = {
            character = true,
            system = true,
            organization = false
        },
        -- A settlement whose Economy outcome is unknown stays pending and is
        -- replayed with its original idempotency key after this delay.
        retryDelaySeconds = 15,
        maximumAttempts = 20,
        -- Committed settlements compared with Economy's journal per reconcile run.
        verifyBatchSize = 100
    },
    Scheduler = {
        intervalMs = 30000,
        batchSize = 25
    },
    Outbox = {
        pollIntervalMs = 1000,
        retryDelaySeconds = 5,
        batchSize = 25
    },
    ClientRoutes = {
        enabled = true
    },
    Limits = {
        readinessTimeoutMs = 30000,
        maximumAmount = 1000000000000,
        maximumPageSize = 50,
        maximumMemoLength = 255,
        maximumReferenceLength = 128,
        maximumRequestIdLength = 128,
        maximumClientRequestIdLength = 64,
        maximumDueSeconds = 31536000,
        maximumTypes = 128
    }
}

-- Development acceptance fixture. Never enable DevMode in production.
if Config.DevMode then
    Config.Access.trustedIssuers['feather-contracts'] = true
end

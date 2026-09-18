CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,

    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT NOT NULL UNIQUE,
    avatar_url TEXT,

    password_hash TEXT NOT NULL,

    role TEXT NOT NULL
        CHECK (role IN ('customer', 'provider')),

    status TEXT NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'disabled')),

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


CREATE TABLE provider_profiles (
    user_id BIGINT PRIMARY KEY
        REFERENCES users(id) ON DELETE CASCADE,

    service_type TEXT NOT NULL
        CHECK (
            service_type IN (
                'cleaner',
                'plumber',
                'cook',
                'sweeper'
            )
        ),

    bio TEXT,

    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,

    status TEXT NOT NULL DEFAULT 'available'
        CHECK (status IN ('available', 'unavailable')),

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


CREATE TABLE bookings (
    id BIGSERIAL PRIMARY KEY,

    customer_id BIGINT NOT NULL
        REFERENCES users(id),

    provider_id BIGINT
        REFERENCES provider_profiles(user_id),

    service_type TEXT NOT NULL
        CHECK (
            service_type IN (
                'cleaner',
                'plumber',
                'cook',
                'sweeper'
            )
        ),

    status TEXT NOT NULL DEFAULT 'requested'
        CHECK (
            status IN (
                'requested',
                'accepted',
                'expired',
                'cancelled',
                'completed'
            )
        ),

    price NUMERIC(10, 2) NOT NULL,

    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    address TEXT NOT NULL,

    expected_duration_min INT NOT NULL,

    dispatched_at TIMESTAMPTZ,

    scheduled_at TIMESTAMPTZ NOT NULL,

    rating INT
        CHECK (rating BETWEEN 1 AND 5),

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


CREATE TABLE refresh_tokens (
    id BIGSERIAL PRIMARY KEY,

    user_id BIGINT NOT NULL
        REFERENCES users(id) ON DELETE CASCADE,

    token_hash TEXT NOT NULL UNIQUE,

    expires_at TIMESTAMPTZ NOT NULL,

    revoked_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
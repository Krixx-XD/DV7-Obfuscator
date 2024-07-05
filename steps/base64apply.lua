-- Import required libraries
local crypto = require("crypto")
local base64 = require("base64")

-- Global Variables
local LATEST_API_VERSION = "0.0.1"

local apiVersions = {}

-- API Version 0.0.1 (Latest)
apiVersions["0.0.1"] = {
    -- Static salt and initialization vector for shorter, less secure links
    salt = string.char(236, 231, 167, 249, 207, 95, 201, 235, 164, 98, 246,
            26, 176, 174, 72, 249),

    iv = string.char(255, 237, 148, 105, 6, 255, 123, 202, 115, 130, 16,
            116),

    -- Generate random salt and initialization vectors
    randomSalt = function()
        return crypto.random(16)
    end,

    randomIv = function()
        return crypto.random(12)
    end,

    -- Derive a key using PBKDF2
    deriveKey = function(self, password, salt)
        salt = salt or self.salt
        return crypto.pbkdf2("sha256", password, salt, 100000, 32)
    end,

    -- Encrypt the text using AES-GCM
    encrypt = function(self, text, password, salt, iv)
        salt = salt or self.salt
        iv = iv or self.iv
        local key = self:deriveKey(password, salt)
        local encrypted = crypto.encrypt("aes-256-gcm", key, iv, text)
        return encrypted
    end,

    -- Decrypt the text using AES-GCM
    decrypt = function(self, text, password, salt, iv)
        salt = salt or self.salt
        iv = iv or self.iv
        local key = self:deriveKey(password, salt)
        local decrypted = crypto.decrypt("aes-256-gcm", key, iv, text)
        return decrypted
    end
}

-- Helper functions for base64 encoding/decoding
local b64 = {
    asciiToBinary = function(str)
        return base64.decode(str)
    end,

    binaryToAscii = function(bin)
        return base64.encode(bin)
    end
}


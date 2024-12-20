local openssl = require("openssl")

-- (должен быть 16, 24 или 32 байта для AES-128, AES-192, AES-256)
local key = "mysecretkey12345"  -- 16 байт для AES-128

-- Функция шифрования
function encrypt(data, key)
    local cipher = openssl.cipher.get('aes-128-cbc')  -- используем AES-128 в режиме CBC
    local iv = openssl.random(16)  
    local encrypted = cipher:encrypt(key, iv, data)  
    return iv .. encrypted  
end

-- Функция дешифрования
function decrypt(encrypted_data, key)
    local cipher = openssl.cipher.get('aes-128-cbc')
    local iv = encrypted_data:sub(1, 16)  
    local data = encrypted_data:sub(17)   
    local decrypted = cipher:decrypt(key, iv, data) 
    return decrypted
end

-- Пример использования
local plaintext = "Hello, this is a secret message!"
print("Original: " .. plaintext)

local encrypted = encrypt(plaintext, key)
print("Encrypted (base64): " .. openssl.base64(encrypted))

local decrypted = decrypt(encrypted, key)
print("Decrypted: " .. decrypted)

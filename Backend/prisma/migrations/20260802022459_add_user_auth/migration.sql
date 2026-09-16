-- CreateTable
CREATE TABLE "addresses" (
    "id" SERIAL NOT NULL,
    "province" VARCHAR(100) NOT NULL,
    "city" VARCHAR(100) NOT NULL,
    "details" VARCHAR(100) NOT NULL,
    "mobile" VARCHAR(100) NOT NULL,
    "postcode" VARCHAR(100) NOT NULL,
    "contact" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "longitude" VARCHAR(100) NOT NULL,
    "latitude" VARCHAR(100) NOT NULL,
    CONSTRAINT "addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "appointment_services" (
    "id" SERIAL NOT NULL,
    "appointment_id" INTEGER NOT NULL,
    "service_id" INTEGER NOT NULL,
    CONSTRAINT "appointment_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "appointment_slots" (
    "id" SERIAL NOT NULL,
    "appointment_id" INTEGER NOT NULL,
    "slot_id" INTEGER NOT NULL,
    CONSTRAINT "appointment_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "appointments" (
    "id" SERIAL NOT NULL,
    "type" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "pet_id" INTEGER NOT NULL,
    "shop_id" INTEGER NOT NULL,
    "groomer_id" INTEGER NOT NULL,
    "origin_price" DECIMAL(10, 2) NOT NULL,
    "discount" DECIMAL(10, 2) NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    "payment_status" INTEGER NOT NULL,
    "appointment_status" INTEGER NOT NULL,
    "notes" VARCHAR(255) NOT NULL,
    CONSTRAINT "appointments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "banners" (
    "id" SERIAL NOT NULL,
    "shop_id" INTEGER NOT NULL,
    "title" VARCHAR(100) NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "image" VARCHAR(255) NOT NULL,
    "url" VARCHAR(255) NOT NULL,
    "activation_status" INTEGER NOT NULL,
    "sort_order" INTEGER NOT NULL,
    CONSTRAINT "banners_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "operation_records" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "operation" VARCHAR(255) NOT NULL,
    "table_name" VARCHAR(100) NOT NULL,
    "time" VARCHAR(100) NOT NULL,
    CONSTRAINT "operation_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_products" (
    "id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "amount" INTEGER NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    CONSTRAINT "order_products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "orders" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "address_id" INTEGER NOT NULL,
    "time" VARCHAR(100) NOT NULL,
    "total_price" DECIMAL(10, 2) NOT NULL,
    "payment_status" INTEGER NOT NULL,
    "order_status" INTEGER NOT NULL,
    "tracking_number" INTEGER NOT NULL,
    CONSTRAINT "orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pet_grooms" (
    "id" SERIAL NOT NULL,
    "pet_id" INTEGER NOT NULL,
    "groom_id" INTEGER NOT NULL,
    "groom_date" VARCHAR(100) NOT NULL,
    CONSTRAINT "pet_grooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pet_vaccines" (
    "id" SERIAL NOT NULL,
    "pet_id" INTEGER NOT NULL,
    "vaccine_name" VARCHAR(100) NOT NULL,
    "vaccine_date" VARCHAR(100) NOT NULL,
    "next_date" VARCHAR(100) NOT NULL,
    CONSTRAINT "pet_vaccines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pet_weights" (
    "id" SERIAL NOT NULL,
    "pet_id" INTEGER NOT NULL,
    "weight" DECIMAL(10, 1) NOT NULL,
    "record_date" VARCHAR(100) NOT NULL,
    "appointment_id" INTEGER NOT NULL,
    CONSTRAINT "pet_weights_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pets" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "avatar" VARCHAR(255) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "gender" INTEGER NOT NULL,
    "category" INTEGER NOT NULL,
    "fur_type" INTEGER NOT NULL,
    "birthday" VARCHAR(100) NOT NULL,
    "activation_status" INTEGER NOT NULL,
    CONSTRAINT "pets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_images" (
    "id" SERIAL NOT NULL,
    "product_id" INTEGER NOT NULL,
    "url" VARCHAR(255) NOT NULL,
    "sort_order" INTEGER NOT NULL,
    CONSTRAINT "product_images_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_stocks" (
    "id" SERIAL NOT NULL,
    "product_id" INTEGER NOT NULL,
    "shop_id" INTEGER NOT NULL,
    "size" VARCHAR(100) NOT NULL,
    "stock" INTEGER NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    "discount" DECIMAL(10, 2) NOT NULL,
    CONSTRAINT "product_stocks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "id" SERIAL NOT NULL,
    "category" INTEGER NOT NULL,
    "type" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "name_zh" VARCHAR(100) NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recharge_bonuses" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "recharge_amount" INTEGER NOT NULL,
    "gift_amount" INTEGER NOT NULL,
    "activation_status" INTEGER NOT NULL,
    "sort_order" INTEGER NOT NULL,
    CONSTRAINT "recharge_bonuses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recharge_records" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "bonus_id" INTEGER NOT NULL,
    "balance_before" DECIMAL(10, 2) NOT NULL,
    "balance_after" DECIMAL(10, 2) NOT NULL,
    "create_time" VARCHAR(100) NOT NULL,
    CONSTRAINT "recharge_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "groomer_slots" (
    "id" SERIAL NOT NULL,
    "groomer_id" INTEGER NOT NULL,
    "start_time" VARCHAR(100) NOT NULL,
    "end_time" VARCHAR(100) NOT NULL,
    CONSTRAINT "room_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rooms" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "type" INTEGER NOT NULL,
    "shop_id" INTEGER NOT NULL,
    CONSTRAINT "rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_prices" (
    "id" SERIAL NOT NULL,
    "service_id" INTEGER NOT NULL,
    "category" INTEGER NOT NULL,
    "fur_type" INTEGER NOT NULL,
    "duration" INTEGER NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    "weight_from" INTEGER NOT NULL,
    "weight_to" INTEGER NOT NULL,
    CONSTRAINT "service_prices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "services" (
    "id" SERIAL NOT NULL,
    "type" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "image" VARCHAR(255) NOT NULL,
    CONSTRAINT "services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shops" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "address" VARCHAR(100) NOT NULL,
    "longitude" VARCHAR(100) NOT NULL,
    "latitude" VARCHAR(100) NOT NULL,
    "contact" VARCHAR(100) NOT NULL,
    "opening_time" VARCHAR(100) NOT NULL,
    "closing_time" VARCHAR(100) NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    CONSTRAINT "shops_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spend_records" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "type" INTEGER NOT NULL,
    "record_id" INTEGER NOT NULL,
    "spend_amount" DECIMAL(10, 2) NOT NULL,
    "balance_before" DECIMAL(10, 2) NOT NULL,
    "balance_after" DECIMAL(10, 2) NOT NULL,
    "create_time" VARCHAR(100) NOT NULL,
    CONSTRAINT "spend_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock_records" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "stock_id" INTEGER NOT NULL,
    "change_amount" INTEGER NOT NULL,
    "change_reason" VARCHAR(100) NOT NULL,
    "change_time" VARCHAR(100) NOT NULL,
    CONSTRAINT "stock_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "username" VARCHAR(100) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "role" INTEGER NOT NULL,
    "shop_id" INTEGER,
    "avatar" VARCHAR(255),
    "mobile" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "balance" DECIMAL(10, 2) NOT NULL,
    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "pet_weights_pet_id_id_idx" ON "pet_weights" ("pet_id", "id");

-- CreateIndex
CREATE INDEX "product_images_product_id_id_idx" ON "product_images" ("product_id", "id");

-- CreateIndex
CREATE INDEX "rooms_shop_id_id_idx" ON "rooms" ("shop_id", "id");

-- CreateIndex
CREATE INDEX "service_prices_service_id_id_idx" ON "service_prices" ("service_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users" ("username");

-- AddForeignKey
ALTER TABLE "pet_weights"
ADD CONSTRAINT "pet_weights_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "pets" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_images"
ADD CONSTRAINT "product_images_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rooms"
ADD CONSTRAINT "rooms_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_prices"
ADD CONSTRAINT "service_prices_service_id_fkey" FOREIGN KEY ("service_id") REFERENCES "services" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
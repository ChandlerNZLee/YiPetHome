import api, { getErrorMessage } from "../api";
import { useEffect, useMemo, useState } from "react";
import "../css/mainPage.css";

import logo from "../assets/imgs/login_logo.png";
import admin from "../assets/imgs/supermanager.png";
import avatar from "../assets/imgs/headimg.png";

import menu1Unselect from "../assets/imgs/tabbar_icon1_gray.png";
import menu1Selected from "../assets/imgs/tabbar_icon1_green.png";
import menu2Unselect from "../assets/imgs/tabbar_icon2_gray.png";
import menu2Selected from "../assets/imgs/tabbar_icon2_green.png";
import menu3Unselect from "../assets/imgs/tabbar_icon3_gray.png";
import menu3Selected from "../assets/imgs/tabbar_icon3_green.png";
import menu4Unselect from "../assets/imgs/tabbar_icon4_gray.png";
import menu4Selected from "../assets/imgs/tabbar_icon4_green.png";
import menu5Unselect from "../assets/imgs/tabbar_icon5_gray.png";
import menu5Selected from "../assets/imgs/tabbar_icon5_green.png";
import menu6Unselect from "../assets/imgs/tabbar_icon6_gray.png";
import menu6Selected from "../assets/imgs/tabbar_icon6_green.png";
import menu7Unselect from "../assets/imgs/tabbar_icon7_gray.png";
import menu7Selected from "../assets/imgs/tabbar_icon7_green.png";
import menu8Unselect from "../assets/imgs/tabbar_icon8_gray.png";
import menu8Selected from "../assets/imgs/tabbar_icon8_green.png";
import menu9Unselect from "../assets/imgs/tabbar_icon9_gray.png";
import menu9Selected from "../assets/imgs/tabbar_icon9_green.png";

const PAGE_SIZE = 10;

const Icon = ({ name, size = 20 }) => {
    const icons = {
        dashboard: <><rect x="3" y="3" width="7" height="7" rx="2" /><rect x="14" y="3" width="7" height="7" rx="2" /><rect x="3" y="14" width="7" height="7" rx="2" /><rect x="14" y="14" width="7" height="7" rx="2" /></>,
        menu: <><path d="M4 6h16M4 12h16M4 18h16" /></>,
        search: <><circle cx="11" cy="11" r="7" /><path d="m20 20-4-4" /></>,
        bell: <><path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9" /><path d="M10 21h4" /></>,
        plus: <><path d="M12 5v14M5 12h14" /></>,
        users: <><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" /><circle cx="9" cy="7" r="4" /><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" /></>,
        paw: <><circle cx="8" cy="8" r="2" /><circle cx="16" cy="8" r="2" /><circle cx="5" cy="13" r="2" /><circle cx="19" cy="13" r="2" /><path d="M8 18c0-3 2-5 4-5s4 2 4 5c0 2-1.5 3-4 3s-4-1-4-3Z" /></>,
        calendar: <><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M16 3v4M8 3v4M3 10h18" /><path d="m9 15 2 2 4-4" /></>,
        wallet: <><path d="M20 7V5a2 2 0 0 0-2-2H5a3 3 0 0 0 0 6h16v10a2 2 0 0 1-2 2H5a3 3 0 0 1-3-3V6" /><path d="M16 14h2" /></>,
        arrowUp: <><path d="m18 15-6-6-6 6" /></>,
        chevron: <><path d="m9 18 6-6-6-6" /></>,
        edit: <><path d="M12 20h9" /><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z" /></>,
        trash: <><path d="M3 6h18M8 6V4h8v2M19 6l-1 15H6L5 6M10 11v6M14 11v6" /></>,
    };

    return (
        <svg className="ui-icon" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
            {icons[name]}
        </svg>
    );
};

const menuList = [
    { id: 0, name: "Dashboard", iconName: "dashboard" },
    { id: 1, name: "Shop Management", unselect: menu1Unselect, selected: menu1Selected },
    { id: 2, name: "Groomer Management", unselect: menu2Unselect, selected: menu2Selected },
    { id: 3, name: "Banner Management", unselect: menu3Unselect, selected: menu3Selected },
    { id: 4, name: "Product Management", unselect: menu4Unselect, selected: menu4Selected },
    { id: 5, name: "Service Management", unselect: menu5Unselect, selected: menu5Selected },
    { id: 6, name: "Booking Management", unselect: menu6Unselect, selected: menu6Selected },
    { id: 7, name: "User Management", unselect: menu7Unselect, selected: menu7Selected },
    { id: 8, name: "Pet Management", unselect: menu8Unselect, selected: menu8Selected },
    { id: 9, name: "Order Management", unselect: menu9Unselect, selected: menu9Selected },
];

const configs = {
    1: {
        endpoint: "/shops",
        empty: "No Shop Data Currently",
        operations: ["Edit", "Reset Password", "Delete"],
        columns: [
            { title: "Shop Name", dataIndex: "name", width: 220 },
            { title: "Address", dataIndex: "address", width: 360 },
            { title: "Description", dataIndex: "description", width: 220 },
            { title: "Longitude", dataIndex: "longitude", width: 140 },
            { title: "Latitude", dataIndex: "latitude", width: 140 },
        ],
    },
    2: {
        endpoint: "/groomers",
        empty: "No Groomer Data Currently",
        operations: ["Edit", "Modify Booking", "Delete"],
        columns: [
            { title: "Groomer Name", dataIndex: "name", width: 180 },
            { title: "Groomer Type", dataIndex: "type", width: 180 },
            { title: "Experience (Yr)", dataIndex: "experience", width: 160 },
            { title: "Served Customers", dataIndex: "customers", width: 180 },
            { title: "Assigned Shop", dataIndex: "shop_name", width: 340 },
        ],
    },
    3: {
        endpoint: "/banners",
        empty: "No Banner Data Currently",
        operations: ["Edit", "Reset Password", "Delete"],
        columns: [
            { title: "Banner Title", dataIndex: "name", width: 220 },
            { title: "Description", dataIndex: "description", width: 280 },
            { title: "Banner Image", dataIndex: "image", width: 180 },
            { title: "Activation", dataIndex: "activation_status", width: 160 },
            { title: "Sort Order", dataIndex: "sort_order", width: 140 },
        ],
    },
    4: {
        endpoint: "/products",
        empty: "No Product Data Currently",
        operations: ["Edit", "Images", "Size", "Delete"],
        columns: [
            { title: "Product Name", dataIndex: "name", width: 420 },
            { title: "Thumbnail", dataIndex: "image", width: 140 },
            { title: "Product Category", dataIndex: "category", width: 200 },
            { title: "Product Type", dataIndex: "type", width: 180 },
        ],
    },
    5: {
        endpoint: "/services",
        empty: "No Service Data Currently",
        operations: ["Edit", "Delete"],
        columns: [
            { title: "Service Name", dataIndex: "name", width: 280 },
            { title: "Pet Category", dataIndex: "category", width: 150 },
            { title: "Service Type", dataIndex: "type", width: 160 },
            { title: "Weight Range (Kg)", dataIndex: "range", width: 180 },
            { title: "Duration (Hr)", dataIndex: "duration", width: 150 },
            { title: "Service Price", dataIndex: "price", width: 140 },
        ],
    },
    6: {
        endpoint: "/appointments",
        empty: "No Appointment Data Currently",
        operations: ["Edit", "Reset Password", "Delete"],
        columns: [
            { title: "Appointment Name", dataIndex: "name", width: 320 },
            { title: "Appointment Address", dataIndex: "address", width: 360 },
            { title: "Appointment Account", dataIndex: "account", width: 280 },
        ],
    },
    7: {
        endpoint: "/users",
        empty: "No User Data Currently",
        operations: ["Edit", "Reset Password", "Delete"],
        columns: [
            { title: "Account", dataIndex: "username", width: 140 },
            { title: "User Role", dataIndex: "role", width: 150 },
            { title: "User Name", dataIndex: "name", width: 180 },
            { title: "Mobile", dataIndex: "mobile", width: 170 },
            { title: "Email", dataIndex: "email", width: 280 },
            { title: "Balance", dataIndex: "balance", width: 120 },
        ],
    },
    8: {
        endpoint: "/pets",
        empty: "No Pet Data Currently",
        operations: ["Edit", "Activate", "Delete"],
        columns: [
            { title: "Pet Name", dataIndex: "name", width: 260 },
            { title: "Avatar", dataIndex: "avatar", width: 100 },
            { title: "Pet Category", dataIndex: "category", width: 150 },
            { title: "Fur Type", dataIndex: "fur_type", width: 140 },
            { title: "Gender", dataIndex: "gender", width: 120 },
            { title: "Weight (Kg)", dataIndex: "weight", width: 140 },
            { title: "Activation", dataIndex: "activation_status", width: 140 },
        ],
    },
    9: {
        endpoint: "/shop-orders",
        empty: "No Order Data Currently",
        operations: ["Edit", "Next Step", "Delete"],
        columns: [
            { title: "Order No.", dataIndex: "trackingNumber", width: 210 },
            { title: "Order Address", dataIndex: "address", width: 400 },
            { title: "Order Account", dataIndex: "user", width: 140 },
            { title: "Order Price", dataIndex: "totalPrice", width: 140 },
            { title: "Order Status", dataIndex: "", width: 140 },
        ],
    },
};

const formatValue = (data, column) => {
    if (column.title === "Groomer Type") return data.type === 0 ? "Senior Groomers" : "Groomers";
    if (column.title === "Product Category") return ["General", "Dog Food", "Cat Food", "Other"][data.category] || "";
    if (column.title === "Product Type") return ["Pet Food", "Snacks", "Toy & Bowl", "Clothes & Nook", "Daily Necessities", "Health & Medicine", "Other"][data.type] || "";
    if (column.title === "Service Type") return ["Washing", "Grooming", "SPA"][data.type] || "";
    if (column.title === "Weight Range (Kg)") {
        if (data.weight_to >= 999) return `${(Number(data.weight_from) / 2).toFixed(1)} and above`;
        return `${(Number(data.weight_from) / 2).toFixed(1)} - ${(Number(data.weight_to) / 2).toFixed(1)}`;
    }
    if (column.title === "Duration (Hr)") return data.duration >= 999 ? "Negotiable" : (Number(data.duration) / 2).toFixed(1);
    if (column.title === "Service Price" && data.price >= 999) return "Negotiable";
    if (column.title === "Fur Type") return data.fur_type === 0 ? "Short Hair" : "Long Hair";
    if (column.title === "Gender") return data.gender === 0 ? "Male" : "Female";
    if (column.title === "Activation") return data.activation_status === 0 ? "Unverified" : "Verified";
    if (column.title === "User Name") return `${data.first_name || ""} ${data.last_name || ""}`.trim();
    if (column.title === "User Role") return ["Administrator", "Shop Manager", "Customer"][data.role] || "Customer";
    if (column.title === "Pet Category") return data.category === 0 ? "Dog" : "Cat";
    if (column.title === "Order Status") {
        if (data.paymentStatus === 0) {
            return "To Pay";
        }

        switch (data.orderStatus) {
            case 1:
                return "Processing";
            case 2:
                return "Completed";
            case 3:
                return "Cancelled";
            default:
                return "Pending";
        }
    }
    return data[column.dataIndex] ?? "-";
};

function MainPage({ username, userrole, onLogout }) {
    const [activeMenu, setActiveMenu] = useState(0);
    const [dataList, setDataList] = useState([]);
    const [selectedIds, setSelectedIds] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [searchValue, setSearchValue] = useState("");
    const [addMenuOpen, setAddMenuOpen] = useState(false);
    const [dashboard, setDashboard] = useState({ users: 0, pets: 0, appointments: 0, revenue: 45678 });
    const [editor, setEditor] = useState({ open: false, mode: "create", record: null });
    const [formData, setFormData] = useState({});
    const [saving, setSaving] = useState(false);
    const [success, setSuccess] = useState("");

    const currentMenu = menuList.find((item) => item.id === activeMenu);
    const config = configs[activeMenu];

    const filteredData = useMemo(() => {
        if (!searchValue.trim()) return dataList;
        const keyword = searchValue.toLowerCase();
        return dataList.filter((row) => Object.values(row).some((value) => String(value ?? "").toLowerCase().includes(keyword)));
    }, [dataList, searchValue]);

    const totalPages = Math.max(1, Math.ceil(filteredData.length / PAGE_SIZE));
    const currentList = filteredData.slice((currentPage - 1) * PAGE_SIZE, currentPage * PAGE_SIZE);
    const isAllSelected = currentList.length > 0 && currentList.every((item) => selectedIds.includes(item.id));

    const loadDashboard = async () => {
        const endpoints = ["/users", "/pets", "/appointments", "/shop-orders"];
        const results = await Promise.allSettled(endpoints.map((endpoint) => api.get(endpoint)));
        const count = (index) => results[index].status === "fulfilled" && Array.isArray(results[index].value.data) ? results[index].value.data.length : 0;
        const orderData = results[3].status === "fulfilled" && Array.isArray(results[3].value.data) ? results[3].value.data : [];
        const revenue = orderData.reduce((sum, item) => sum + Number(item.total || item.amount || item.price || 0), 0);
        setDashboard({ users: count(0), pets: count(1), appointments: count(2), revenue: revenue || 45678 });
    };

    const fetchData = async (menuId) => {
        if (menuId === 0) {
            setDataList([]);
            setCurrentPage(1);
            setSelectedIds([]);
            setError("");
            loadDashboard();
            return;
        }

        const target = configs[menuId];
        if (!target) return;

        setLoading(true);
        setError("");
        try {
            const res = await api.get(target.endpoint);
            let rows = Array.isArray(res.data) ? res.data : [];



            setDataList(rows);
            setCurrentPage(1);
            setSelectedIds([]);
        } catch (err) {
            console.error(err);
            setDataList([]);
            setError("Unable to load data. Please check whether the API service is running.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData(0);
    }, []);

    const changeMenu = (menuId) => {
        setActiveMenu(menuId);
        setSearchValue("");
        fetchData(menuId);
    };

    const handleSelectAll = (event) => {
        const pageIds = currentList.map((item) => item.id);
        if (event.target.checked) {
            setSelectedIds((prev) => [...new Set([...prev, ...pageIds])]);
        } else {
            setSelectedIds((prev) => prev.filter((id) => !pageIds.includes(id)));
        }
    };

    const handleSelectOne = (id) => {
        setSelectedIds((prev) => prev.includes(id) ? prev.filter((item) => item !== id) : [...prev, id]);
    };

    const editableFields = useMemo(() => {
        const byMenu = {
            1: [
                { key: "name", label: "Shop Name", type: "text" }, { key: "address", label: "Address", type: "text" },
                { key: "longitude", label: "Longitude", type: "text" }, { key: "latitude", label: "Latitude", type: "text" },
                { key: "contact", label: "Contact", type: "text" }, { key: "openingTime", source: "openingTime", label: "Opening Time", type: "text" },
                { key: "closingTime", source: "closingTime", label: "Closing Time", type: "text" }, { key: "description", label: "Description", type: "textarea" },
                ...(editor.mode === "create" ? [{ key: "image", label: "Image URL", type: "text" }] : []),
            ],
            2: [
                { key: "shopId", label: "Shop ID", type: "number" }, { key: "name", label: "Groomer Name", type: "text" },
                { key: "_type", source: "_type", label: "Groomer Type", type: "number" }, { key: "experience", label: "Experience (Yr)", type: "number" },
                { key: "customers", label: "Served Customers", type: "number" }, { key: "description", label: "Description", type: "textarea" },
                ...(editor.mode === "create" ? [{ key: "avatar", label: "Avatar URL", type: "text" }, { key: "price", label: "Price", type: "number" }] : []),
            ],
            3: [
                { key: editor.mode === "create" ? "shopId" : "shopId", source: "shopId", label: "Shop ID", type: "number" },
                { key: "title", label: "Banner Title", type: "text" }, { key: "description", label: "Description", type: "textarea" },
                { key: "image", label: "Image URL", type: "text" }, { key: "url", label: "Target URL", type: "text" },
                { key: "activationStatus", source: "activationStatus", label: "Activation Status", type: "number" }, { key: "sortOrder", source: "sortOrder", label: "Sort Order", type: "number" },
            ],
            4: [
                { key: "category", label: "Product Category", type: "number" }, { key: "_type", source: "_type", label: "Product Type", type: "number" },
                { key: "name", label: "Product Name", type: "text" }, { key: "nameZh", source: "nameZh", label: "Chinese Name", type: "text" },
                { key: "description", label: "Description", type: "textarea" },
            ],
            5: [
                { key: "_type", source: "_type", label: "Service Type", type: "number" }, { key: "name", label: "Service Name", type: "text" },
                { key: "image", label: "Image URL", type: "text" }, { key: "description", label: "Description", type: "textarea" },
            ],
            6: editor.mode === "create" ? [
                { key: "userId", label: "User ID", type: "number" }, { key: "petId", label: "Pet ID", type: "number" },
                { key: "shopId", label: "Shop ID", type: "number" }, { key: "groomerId", label: "Groomer ID", type: "number" },
                { key: "servicePriceIds", label: "Service Price IDs (comma separated)", type: "text", array: true },
                { key: "startAt", label: "Start At (ISO 8601)", type: "datetime-local", date: true }, { key: "notes", label: "Notes", type: "textarea", optional: true },
            ] : [{ key: "notes", label: "Notes", type: "textarea", optional: true }],
            7: editor.mode === "create" ? [
                { key: "username", label: "Account", type: "text" }, { key: "password", label: "Password", type: "password" },
                { key: "role", label: "Role", type: "number" }, { key: "shopId", label: "Shop ID", type: "number" }, { key: "avatar", label: "Avatar URL", type: "text" },
                { key: "mobile", label: "Mobile", type: "text" }, { key: "email", label: "Email", type: "email" },
                { key: "firstName", label: "First Name", type: "text" }, { key: "lastName", label: "Last Name", type: "text" }, { key: "balance", label: "Balance", type: "number" },
            ] : [
                { key: "username", label: "Account", type: "text", optional: true }, { key: "role", label: "Role", type: "number", optional: true },
                { key: "shopId", source: "shopId", label: "Shop ID", type: "number", optional: true }, { key: "avatar", label: "Avatar URL", type: "text", optional: true },
                { key: "mobile", label: "Mobile", type: "text", optional: true }, { key: "email", label: "Email", type: "email", optional: true },
                { key: "firstName", source: "firstName", label: "First Name", type: "text", optional: true }, { key: "lastName", source: "lastName", label: "Last Name", type: "text", optional: true },
                { key: "balance", label: "Balance", type: "number", optional: true },
            ],
            8: [
                { key: "userId", label: "User ID", type: "number" }, { key: "avatar", label: "Avatar URL", type: "text" }, { key: "name", label: "Pet Name", type: "text" },
                { key: "gender", label: "Gender", type: "number" }, { key: "category", label: "Pet Category", type: "number" }, { key: "furType", source: "furType", label: "Fur Type", type: "number" },
                { key: "birthday", label: "Birthday", type: "date" }, { key: "activationStatus", source: "activationStatus", label: "Activation Status", type: "number" },
            ],
            9: editor.mode === "create" ? [
                { key: "userId", label: "User ID", type: "number" }, { key: "addressId", label: "Address ID", type: "number" },
                { key: "products", label: "Products JSON", type: "textarea", json: true, placeholder: '[{"productId":1,"stockId":1,"quantity":1,"price":100}]' },
            ] : [
                { key: "userId", source: "userId", label: "User ID", type: "number" }, { key: "addressId", source: "addressId", label: "Address ID", type: "number" },
                { key: "time", label: "Time", type: "text" }, { key: "totalPrice", source: "totalPrice", label: "Total Price", type: "text" },
                { key: "paymentStatus", source: "paymentStatus", label: "Payment Status", type: "number" }, { key: "orderStatus", source: "orderStatus", label: "Order Status", type: "number" },
                { key: "trackingNumber", source: "trackingNumber", label: "Tracking Number", type: "number" },
            ],
        };
        return byMenu[activeMenu] || [];
    }, [activeMenu, editor.mode]);

    const openEditor = (mode, record = null) => {
        const initial = {};
        editableFields.forEach((field) => {
            initial[field.key] = record?.[field.source || field.key] ?? "";
        });
        if (activeMenu === 7 && record) {
            initial.name = `${record.first_name || ""} ${record.last_name || ""}`.trim() || record.name || "";
        }
        setFormData(initial);
        setEditor({ open: true, mode, record });
        setError("");
        setSuccess("");
        setAddMenuOpen(false);
    };

    const handleAdd = () => {
        if (activeMenu === 0) return changeMenu(7);
        openEditor("create");
    };

    const buildPayload = () => {
        const payload = { ...formData };
        editableFields.forEach((field) => {
            if (field.type === "number" && payload[field.key] !== "") payload[field.key] = Number(payload[field.key]);
            if (field.array && typeof payload[field.key] === "string") payload[field.key] = payload[field.key].split(",").map((v) => Number(v.trim())).filter(Number.isFinite);
            if (field.json && typeof payload[field.key] === "string") payload[field.key] = JSON.parse(payload[field.key] || "[]");
            if (field.date && payload[field.key]) payload[field.key] = new Date(payload[field.key]).toISOString();
            if (field.optional && payload[field.key] === "") delete payload[field.key];
        });
        return payload;
    };

    const saveRecord = async (event) => {
        event.preventDefault();
        if (!config) return;
        setSaving(true);
        setError("");
        setSuccess("");
        try {
            const payload = buildPayload();
            if (editor.mode === "create") {
                await api.post(config.endpoint, payload);
                setSuccess("Created successfully.");
            } else {
                const id = editor.record?.id;
                if (!id) throw new Error("Missing record id.");
                await api.put(`${config.endpoint}/${id}`, payload);
                setSuccess("Updated successfully.");
            }
            setEditor({ open: false, mode: "create", record: null });
            await fetchData(activeMenu);
        } catch (err) {
            console.error(err);
            setError(getErrorMessage(err, `Unable to ${editor.mode} record.`));
        } finally {
            setSaving(false);
        }
    };

    const deleteRecord = async (data) => {
        if (!config || !data?.id) return;
        if (!window.confirm(`Delete ${data.name || data.username || data.trackingNumber || data.id}? This action cannot be undone.`)) return;
        setLoading(true);
        setError("");
        setSuccess("");
        try {
            await api.delete(`${config.endpoint}/${data.id}`);
            setSuccess("Deleted successfully.");
            await fetchData(activeMenu);
        } catch (err) {
            console.error(err);
            setError(getErrorMessage(err, "Unable to delete record."));
        } finally {
            setLoading(false);
        }
    };

    const handleBatchDelete = async () => {
        if (!selectedIds.length) return alert("Please select data to delete first.");
        if (!window.confirm(`Confirm deleting ${selectedIds.length} selected item(s)? This action cannot be undone.`)) return;
        setLoading(true);
        setError("");
        setSuccess("");
        try {
            const results = await Promise.allSettled(selectedIds.map((id) => api.delete(`${config.endpoint}/${id}`)));
            const failed = results.filter((result) => result.status === "rejected");
            if (failed.length) setError(`${failed.length} item(s) could not be deleted.`);
            else setSuccess(`${selectedIds.length} item(s) deleted successfully.`);
            setSelectedIds([]);
            await fetchData(activeMenu);
        } finally {
            setLoading(false);
        }
    };

    const handleOperation = async (data, operation) => {
        if (operation === "Edit") openEditor("edit", data);
        else if (operation === "Delete") await deleteRecord(data);
        else if (operation === "Reset Password") {
            if (!window.confirm(`Reset password for ${data.account || data.username || data.name || data.id}?`)) return;
            try {
                await api.post(`${config.endpoint}/${data.id}/reset-password`);
                setSuccess("Password has been reset.");
            } catch (err) {
                setError(getErrorMessage(err, "Unable to reset password."));
            }
        } else if (operation === "Activate") {
            try {
                await api.put(`${config.endpoint}/${data.id}`, { ...data, activationStatus: 1 });
                setSuccess("Activated successfully.");
                await fetchData(activeMenu);
            } catch (err) {
                setError(getErrorMessage(err, "Unable to activate record."));
            }
        } else if (operation === "Next Step") goToNextStep(data);
        else alert(`${operation}: ${data.name || data.id}`);
    };

    const goToNextStep = async (data) => {
        if (data.paymentStatus == 1 && (data.orderStatus === 0 || data.orderStatus === 1)) {
            setError("");
            try {
                await api.post(`/shop-orders/process/${data.id}`);
                fetchData(activeMenu);
            } catch (err) {
                console.error(err);
                setDataList([]);
                setError(getErrorMessage(err, "Unable to process order."));
            } finally {
                setLoading(false);
            }
        }
    }

    const statCards = [
        { label: "Total Users", value: dashboard.users.toLocaleString(), change: "8.2%", icon: "users" },
        { label: "Total Pets", value: dashboard.pets.toLocaleString(), change: "12.5%", icon: "paw" },
        { label: "Appointments", value: dashboard.appointments.toLocaleString(), change: "6.8%", icon: "calendar" },
        { label: "Total Revenue", value: `$${Number(dashboard.revenue).toLocaleString()}`, change: "15.3%", icon: "wallet" },
    ];

    return (
        <div className="management-layout">
            <aside className="sidebar">
                <div className="sidebar-logo">
                    <img className="sidebar-logo-img" src={logo} alt="YiPet" />
                    <div className="brand-copy"><strong>YiPet</strong><span>Admin</span></div>
                </div>
                <nav className="sidebar-menu">
                    {menuList.map((menu) => (
                        <button key={menu.id} type="button" className={`sidebar-menu-item ${activeMenu === menu.id ? "active" : ""}`} onClick={() => changeMenu(menu.id)}>
                            {menu.iconName ? <Icon name={menu.iconName} size={19} /> : <img className="menu-icon" src={activeMenu === menu.id ? menu.selected : menu.unselect} alt="" />}
                            <span>{menu.name}</span>
                        </button>
                    ))}
                </nav>
                <div className="sidebar-footer">
                    <div className="profile-card">
                        <img src={avatar} alt="User avatar" />
                        <div><strong>{username || "Chandler"}</strong><span>{userrole === 0 ? "Admin" : "Manager"}</span></div>
                        <button type="button" onClick={onLogout}>⌄</button>
                    </div>
                    <div className="ai-card">
                        <div className="ai-copy"><strong>YiPet AI<br />Assistant</strong><span>Smart support for you<br />and your pet</span><button type="button">Try Now →</button></div>
                        <div className="ai-robot">🤖</div>
                    </div>
                </div>
            </aside>
            <main className="main-area">
                <header className="top-header">
                    <button className="header-icon-button" type="button" aria-label="Menu"><Icon name="menu" /></button>
                    <div className="header-actions">
                        <label className="search-box"><input value={searchValue} onChange={(e) => { setSearchValue(e.target.value); setCurrentPage(1); }} placeholder="Search anything..." /><Icon name="search" size={18} /></label>
                        <button className="notification-button" type="button" aria-label="Notifications"><Icon name="bell" size={21} /><span>8</span></button>
                        <div className="add-new-wrap">
                            <button className="header-add-button" type="button" onClick={() => setAddMenuOpen((open) => !open)}><Icon name="plus" size={18} />Add New <span className="caret">⌄</span></button>
                            {addMenuOpen && <div className="add-new-menu"><button type="button" onClick={handleAdd}>Add current item</button><button type="button" onClick={() => changeMenu(7)}>Add user</button><button type="button" onClick={() => changeMenu(4)}>Add product</button></div>}
                        </div>
                    </div>
                </header>
                {activeMenu === 0 ? (
                    <section className="dashboard-content">
                        <div className="welcome-banner">
                            <div><h1>Welcome back, {username || "Admin"}! <span>👋</span></h1><p>Here’s what’s happening with your YiPet platform today.</p></div>
                            <div className="pet-scene" aria-hidden="true"><span className="leaf leaf-a">●</span><span className="pet-dog">🐶</span><span className="pet-cat">🐱</span><span className="leaf leaf-b">●</span></div>
                        </div>
                        <div className="stat-grid">
                            {statCards.map((card) => <article className="stat-card" key={card.label}><div className="stat-icon"><Icon name={card.icon} size={26} /></div><div><span className="stat-label">{card.label}</span><strong>{card.value}</strong><small><Icon name="arrowUp" size={12} /> {card.change} <em>from last month</em></small></div></article>)}
                        </div>
                        <div className="dashboard-grid">
                            <article className="panel overview-panel">
                                <div className="panel-head"><h3>Overview</h3><button type="button">This Month ⌄</button></div>
                                <div className="chart-wrap">
                                    <div className="y-axis"><span>4K</span><span>3K</span><span>2K</span><span>1K</span><span>0</span></div>
                                    <svg viewBox="0 0 720 250" preserveAspectRatio="none" className="line-chart" aria-label="Overview chart"><defs><linearGradient id="areaFill" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stopColor="#21c45b" stopOpacity=".22" /><stop offset="100%" stopColor="#21c45b" stopOpacity="0" /></linearGradient></defs><path className="grid-line" d="M0 24H720M0 79H720M0 134H720M0 189H720M0 244H720" /><path className="area" d="M0 170 C45 155,60 132,92 145 S130 208,180 183 S215 100,260 108 S300 159,350 150 S390 86,430 108 S470 94,520 116 S575 150,620 125 S665 75,720 66 L720 250 L0 250 Z" /><path className="trend" d="M0 170 C45 155,60 132,92 145 S130 208,180 183 S215 100,260 108 S300 159,350 150 S390 86,430 108 S470 94,520 116 S575 150,620 125 S665 75,720 66" /><circle cx="430" cy="108" r="6" className="point" /></svg>
                                    <div className="x-axis"><span>May 1</span><span>May 7</span><span>May 13</span><span>May 19</span><span>May 25</span><span>May 31</span></div>
                                </div>
                            </article>
                            <article className="panel services-panel"><div className="panel-head"><h3>Top Services</h3></div><div className="service-content"><div className="donut-chart"></div><div className="legend"><span><i></i>Grooming <b>45%</b></span><span><i></i>Health Check <b>25%</b></span><span><i></i>Vaccination <b>15%</b></span><span><i></i>Training <b>10%</b></span><span><i></i>Others <b>5%</b></span></div></div></article>
                            <article className="panel activities-panel"><div className="panel-head"><h3>Recent Activities</h3></div><div className="activity-list">{[["users", "New user registered", "5 min ago"], ["calendar", "New appointment booked", "15 min ago"], ["wallet", "Payment received", "1 hour ago"], ["paw", "Health record updated", "2 hours ago"], ["calendar", "New product added", "3 hours ago"]].map(([icon, title, time]) => <div className="activity-item" key={title}><span className="activity-icon"><Icon name={icon} size={17} /></span><div><strong>{title}</strong><small>{time}</small></div></div>)}</div><button className="view-link" type="button">View all activities →</button></article>
                            <article className="panel appointments-panel"><div className="panel-head"><h3>Recent Appointments</h3></div><div className="mini-table"><div className="mini-row mini-head"><span>Pet</span><span>Owner</span><span>Service</span><span>Time</span><span>Status</span></div>{[["Milo", "Chandler", "Grooming", "May 20, 2:00 PM", "Confirmed"], ["Luna", "Jessica", "Health Check", "May 20, 3:30 PM", "Pending"], ["Buddy", "Michael", "Training", "May 21, 10:00 AM", "Confirmed"], ["Coco", "Sarah", "Vaccination", "May 21, 11:30 AM", "Pending"]].map((row) => <div className="mini-row" key={row[0]}><span><b className="pet-avatar">{row[0][0]}</b>{row[0]}</span><span>{row[1]}</span><span>{row[2]}</span><span>{row[3]}</span><span><em className={`status ${row[4].toLowerCase()}`}>{row[4]}</em></span></div>)}</div><button className="view-link" type="button" onClick={() => changeMenu(6)}>View all appointments →</button></article>
                            <article className="panel products-panel"><div className="panel-head"><h3>Top Products</h3><span>Sales</span></div><div className="product-list">{[["Premium Dog Food", "1,245", "🥫"], ["Dental Chews", "987", "🦴"], ["Cat Litter", "756", "📦"], ["Pet Shampoo", "654", "🧴"], ["Dog Treats", "543", "🍖"]].map(([name, sales, emoji]) => <div key={name}><span className="product-emoji">{emoji}</span><strong>{name}</strong><span>{sales}</span></div>)}</div><button className="view-link" type="button" onClick={() => changeMenu(4)}>View all products →</button></article>
                        </div>
                    </section>
                ) : (
                    <section className="content-section">
                        <div className="page-heading-row"><div><h1>{currentMenu?.name}</h1><p>Manage your YiPet {currentMenu?.name.toLowerCase()} data.</p></div><div className="table-actions"><button className="outline-danger" type="button" onClick={handleBatchDelete}><Icon name="trash" size={17} />Batch Delete</button><button className="primary-button" type="button" onClick={handleAdd}><Icon name="plus" size={17} />Add New</button></div></div>
                        <div className="data-card">
                            {error && <div className="error-message">{error}</div>}
                            {success && <div className="success-message">{success}</div>}
                            <div className="table-wrapper">
                                <table className="store-table">
                                    <thead><tr><th className="checkbox-column"><input type="checkbox" checked={isAllSelected} onChange={handleSelectAll} /></th>{config?.columns.map((column) => <th key={column.dataIndex} style={{ width: column.width }}>{column.title}</th>)}<th className="operation-column">Operate</th></tr></thead>
                                    <tbody>
                                        {loading ? <tr><td colSpan={(config?.columns.length || 0) + 2} className="empty-table">Loading...</td></tr> : currentList.length ? currentList.map((data) => <tr key={data.id}><td className="checkbox-column"><input type="checkbox" checked={selectedIds.includes(data.id)} onChange={() => handleSelectOne(data.id)} /></td>{config.columns.map((column) => <td key={column.dataIndex}>{["avatar", "image"].includes(column.dataIndex) && data[column.dataIndex] ? <img className="column-img" src={data[column.dataIndex]} alt="" /> : formatValue(data, column)}</td>)}<td><div className="operation-buttons">{config.operations.map((operation) => operation === "Activate" && data.activation_status !== 0 ? null : <button key={operation} type="button" className={operation === "Edit" ? "edit-button" : operation === "Delete" ? "delete-button" : operation === "Images" ? "images-button" : operation === "Size" || operation === "Activate" ? "activate-button" : "default-button"} onClick={() => handleOperation(data, operation)}>{operation === "Edit" && <Icon name="edit" size={14} />} {operation}</button>)}</div></td></tr>) : <tr><td colSpan={(config?.columns.length || 0) + 2} className="empty-table">{config?.empty}</td></tr>}
                                    </tbody>
                                </table>
                            </div>
                            <div className="pagination"><span>{filteredData.length} items</span><div><button type="button" onClick={() => setCurrentPage((p) => Math.max(1, p - 1))} disabled={currentPage === 1}>‹</button><span>{currentPage}</span><button type="button" onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))} disabled={currentPage === totalPages}>›</button></div><span>Page {currentPage} of {totalPages}</span></div>
                        </div>
                    </section>
                )}
            </main>
            {editor.open && (
                <div className="crud-modal-backdrop" role="presentation" onMouseDown={(event) => event.target === event.currentTarget && !saving && setEditor({ open: false, mode: "create", record: null })}>
                    <section className="crud-modal" role="dialog" aria-modal="true" aria-label={`${editor.mode} record`}>
                        <div className="crud-modal-head">
                            <div><span>{editor.mode === "create" ? "Create" : "Update"}</span><h2>{currentMenu?.name}</h2></div>
                            <button type="button" onClick={() => setEditor({ open: false, mode: "create", record: null })} disabled={saving}>×</button>
                        </div>
                        <form onSubmit={saveRecord}>
                            <div className="crud-form-grid">
                                {editableFields.map((field) => (
                                    <label key={field.key} className={field.type === "textarea" ? "full-width" : ""}>
                                        <span>{field.label}</span>
                                        {field.type === "textarea" ? (
                                            <textarea required={!field.optional} placeholder={field.placeholder || ""} value={formData[field.key] ?? ""} onChange={(event) => setFormData((prev) => ({ ...prev, [field.key]: event.target.value }))} rows="4" />
                                        ) : (
                                            <input required={!field.optional} type={field.type} value={formData[field.key] ?? ""} onChange={(event) => setFormData((prev) => ({ ...prev, [field.key]: event.target.value }))} />
                                        )}
                                    </label>
                                ))}
                            </div>
                            <div className="crud-modal-actions">
                                <button type="button" className="crud-cancel" onClick={() => setEditor({ open: false, mode: "create", record: null })} disabled={saving}>Cancel</button>
                                <button type="submit" className="primary-button" disabled={saving}>{saving ? "Saving..." : editor.mode === "create" ? "Create" : "Save Changes"}</button>
                            </div>
                        </form>
                    </section>
                </div>
            )}
        </div>
    );
}

export default MainPage;

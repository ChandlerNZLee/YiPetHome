import api, { getErrorMessage } from "../api";
import { useEffect, useMemo, useRef, useState } from "react";
import "../css/mainPage.css";

import AIChat from "./AIChat";

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

const DEFAULT_PAGE_SIZE = 10;

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
        logout: <><path d="M10 17l5-5-5-5M15 12H3" /><path d="M14 3h5a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-5" /></>,
        user: <><circle cx="12" cy="8" r="4" /><path d="M4 21a8 8 0 0 1 16 0" /></>,
        panel: <><path d="M4 4h16v16H4zM9 4v16" /></>,
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
    { id: 3, name: "Recharge Management", unselect: menu3Unselect, selected: menu3Selected },
    { id: 4, name: "Product Management", unselect: menu4Unselect, selected: menu4Selected },
    { id: 5, name: "Service Management", unselect: menu5Unselect, selected: menu5Selected },
    { id: 6, name: "Booking Management", unselect: menu6Unselect, selected: menu6Selected },
    { id: 7, name: "User Management", unselect: menu7Unselect, selected: menu7Selected },
    { id: 8, name: "Pet Management", unselect: menu8Unselect, selected: menu8Selected },
    { id: 9, name: "Order Management", unselect: menu9Unselect, selected: menu9Selected },
];

const ROLE_ACCESS = {
    0: menuList.map((item) => item.id),
    1: [0, 2, 4, 5, 6, 8, 9],
};
const ADMIN_ONLY_OPERATIONS = new Set(["Delete", "Reset Password", "Toggle Status"]);

const configs = {
    1: {
        endpoint: "/shops",
        empty: "No Shop Data Currently",
        operations: ["View", "Edit", "Delete"],
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
        endpoint: "/recharge-bonuses",
        empty: "No Recharge Bonus Data Currently",
        operations: ["Edit", "Toggle Status", "Delete"],
        columns: [
            { title: "Recharge Plan", dataIndex: "name", width: 260 },
            { title: "Recharge Amount", dataIndex: "rechargeAmount", width: 180 },
            { title: "Gift Amount", dataIndex: "giftAmount", width: 170 },
            { title: "Activation", dataIndex: "activationStatus", width: 150 },
            { title: "Sort Order", dataIndex: "sortOrder", width: 140 },
        ],
    },
    4: {
        endpoint: "/products",
        empty: "No Product Data Currently",
        operations: ["View", "Edit", "Images", "Size", "Delete"],
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
        operations: ["Edit", "Prices", "Delete"],
        columns: [
            { title: "Service Name", dataIndex: "name", width: 260 },
            { title: "Description", dataIndex: "description", width: 170 },
            { title: "Service Type", dataIndex: "type", width: 160 },
        ],
    },
    6: {
        endpoint: "/appointments",
        empty: "No Appointment Data Currently",
        operations: ["View", "Edit", "Services", "Complete", "Cancel", "Delete"],
        columns: [
            { title: "Service Name", dataIndex: "name", width: 260 },
            { title: "Start Time", dataIndex: "startAt", width: 190 },
            { title: "Appointment Status", dataIndex: "appointmentStatus", width: 170 },
            { title: "Payment Status", dataIndex: "paymentStatus", width: 150 },
        ],
    },
    7: {
        endpoint: "/users",
        empty: "No User Data Currently",
        operations: ["View", "Edit", "Reset Password", "Delete"],
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
        operations: ["View", "Edit", "Activate", "Delete"],
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
        operations: ["View", "Edit", "Next Step", "Delete"],
        columns: [
            { title: "Order No.", dataIndex: "trackingNumber", width: 210 },
            { title: "Order Address", dataIndex: "address", width: 400 },
            { title: "Order Account", dataIndex: "user", width: 140 },
            { title: "Order Price", dataIndex: "totalPrice", width: 140 },
            { title: "Order Status", dataIndex: "", width: 140 },
        ],
    },
};

const relationConfigs = {
    Images: {
        title: "Product Images", endpoint: "/product-images", parentKey: "productId",
        fields: [
            { key: "url", label: "Image URL", type: "text" },
            { key: "sortOrder", label: "Sort Order", type: "number" },
        ],
        columns: ["id", "url", "sortOrder"],
    },
    Size: {
        title: "Product Stock / Size", endpoint: "/product-stocks", parentKey: "productId",
        fields: [
            { key: "shopId", label: "Assigned Shop", type: "select", lookup: "shops", numeric: true },
            { key: "size", label: "Size", type: "text" },
            { key: "stock", label: "Stock", type: "number" },
            { key: "price", label: "Price", type: "number" },
            { key: "discount", label: "Discount", type: "number" },
        ],
        columns: ["id", "shopId", "size", "stock", "price", "discount"],
    },
    Prices: {
        title: "Service Prices", endpoint: "/service-prices", parentKey: "serviceId",
        fields: [
            { key: "category", label: "Pet Category", type: "number" },
            { key: "furType", label: "Fur Type", type: "number" },
            { key: "duration", label: "Duration", type: "number" },
            { key: "price", label: "Price", type: "number" },
            { key: "weightFrom", label: "Weight From", type: "number" },
            { key: "weightTo", label: "Weight To", type: "number" },
        ],
        columns: ["id", "category", "furType", "duration", "price", "weightFrom", "weightTo"],
    },
    Services: {
        title: "Appointment Services", endpoint: "/appointment-services", parentKey: "appointmentId",
        fields: [
            { key: "serviceId", label: "Service", type: "select", lookup: "services", numeric: true },
            { key: "price", label: "Price", type: "number" },
            { key: "duration", label: "Duration", type: "number" },
        ],
        columns: ["id", "serviceId", "price", "duration"],
    },
};

const appointmentStatusLabel = (status) => ["Pending Payment", "Confirmed", "Completed", "Cancelled", "Expired"][Number(status)] || "Unknown";
const paymentStatusLabel = (status) => ["Pending", "Paid", "Failed", "Cancelled", "Refunded"][Number(status)] || "Unknown";
const orderStatusLabel = (status) => ["Pending", "Processing", "Completed", "Cancelled"][Number(status)] || "Unknown";
const statusTone = (label) => String(label).toLowerCase().replace(/\s+/g, "-");
const StatusBadge = ({ label }) => <span className={`business-status ${statusTone(label)}`}>{label}</span>;

const formatValue = (data, column, menuId, lookups) => {
    if (column.title === "Recharge Amount") return `$${Number(data.rechargeAmount ?? 0).toFixed(2)}`;
    if (column.title === "Gift Amount") return `$${Number(data.giftAmount ?? 0).toFixed(2)}`;
    if (column.title === "Activation" && Object.prototype.hasOwnProperty.call(data, "activationStatus")) { const label = Number(data.activationStatus) === 1 ? "Active" : "Inactive"; return <StatusBadge label={label} />; }
    if (column.title === "Groomer Type") return data.type === 0 ? "Senior Groomers" : "Groomers";
    if (column.title === "Product Category") return ["General", "Dog Food", "Cat Food", "Other"][data.category] || "";
    if (column.title === "Product Type") return ["Pet Food", "Snacks", "Toy & Bowl", "Clothes & Nook", "Daily Necessities", "Health & Medicine", "Other"][data._type] || "";
    if (column.title === "Service Type") return ["Washing", "Grooming", "SPA", "Addon"][data._type] || "";
    if (column.title === "Fur Type") return data.fur_type === 0 ? "Short Hair" : "Long Hair";
    if (column.title === "Gender") return data.gender === 0 ? "Male" : "Female";
    if (column.title === "Activation") return data.activation_status === 0 ? "Unverified" : "Verified";
    if (column.title === "User Name") {
        const lastName = data.lastName ?? data.last_name ?? "";
        const firstName = data.firstName ?? data.first_name ?? "";

        return `${firstName} ${lastName}`.trim() || "-";
    }
    if (column.title === "User Role") return ["Administrator", "Shop Manager", "Customer"][data.role] || "Customer";
    if (column.title === "Pet Category") return data.category === 0 ? "Dog" : "Cat";
    if (menuId === 6 && column.title === "Service Name") return getAppointmentServiceName(data, lookups);
    if (column.title === "Appointment Status") return <StatusBadge label={appointmentStatusLabel(data.appointmentStatus)} />;
    if (column.title === "Payment Status") return <StatusBadge label={paymentStatusLabel(data.paymentStatus)} />;
    if (column.title === "Start Time") return data.startAt ? new Date(data.startAt).toLocaleString() : "-";
    if (column.title === "Order Status") { const label = Number(data.paymentStatus) === 0 ? "To Pay" : orderStatusLabel(data.orderStatus); return <StatusBadge label={label} />; }
    return data[column.dataIndex] ?? "-";
};

const formatDetailLabel = (key, menuId) => {
    if (menuId === 4 && key === "_type") {
        return "Product Type";
    }

    return key
        .replace(/([A-Z])/g, " $1")
        .replace(/_/g, " ")
        .replace(/^./, (c) => c.toUpperCase());
};

const formatDetailValue = (key, value, menuId) => {
    if (value == null || value === "") {
        return "—";
    }

    // =========================
    // Product Management
    // =========================
    if (menuId === 4) {
        if (key === "_type") {
            return [
                "Pet Food",
                "Snacks",
                "Toy & Bowl",
                "Clothes & Nook",
                "Daily Necessities",
                "Health & Medicine",
                "Other",
            ][Number(value)] ?? `Unknown (${value})`;
        }

        if (key === "category") {
            return [
                "General",
                "Dog Food",
                "Cat Food",
                "Other",
            ][Number(value)] ?? `Unknown (${value})`;
        }
    }

    // =========================
    // Service Management
    // =========================
    if (menuId === 5) {
        if (key === "_type") {
            return [
                "Washing",
                "Grooming",
                "SPA",
                "Addon",
            ][Number(value)] ?? `Unknown (${value})`;
        }
    }

    // =========================
    // User Management
    // =========================
    if (menuId === 7) {
        if (key === "role") {
            return [
                "Administrator",
                "Shop Manager",
                "Customer",
            ][Number(value)] ?? `Unknown (${value})`;
        }
    }

    // =========================
    // Object / Array
    // =========================
    if (typeof value === "object") {
        return JSON.stringify(value);
    }

    return String(value);
};

const getAppointmentServiceName = (appointment, lookups) => {
    if (!appointment?.id) {
        return "—";
    }

    const appointmentServices = lookups?.appointmentServices || [];
    const services = lookups?.services || [];

    const relations = appointmentServices.filter(
        (item) =>
            Number(item.appointmentId) === Number(appointment.id)
    );

    if (relations.length === 0) {
        return "—";
    }

    const serviceNames = relations
        .map((relation) => {
            const service = services.find(
                (item) =>
                    Number(item.id) === Number(relation.serviceId)
            );

            return service?.name || null;
        })
        .filter(Boolean);

    if (serviceNames.length === 0) {
        return "—";
    }

    return [...new Set(serviceNames)].join(", ");
};

function MainPage({ username, userrole, onLogout }) {
    const [activeMenu, setActiveMenu] = useState(0);
    const [aiPageOpen, setAiPageOpen] = useState(false);
    const [sidebarCollapsed, setSidebarCollapsed] = useState(() => localStorage.getItem("sidebarCollapsed") === "1");
    const [mobileSidebarOpen, setMobileSidebarOpen] = useState(false);
    const [profileMenuOpen, setProfileMenuOpen] = useState(false);
    const [dataList, setDataList] = useState([]);
    const [selectedIds, setSelectedIds] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [searchValue, setSearchValue] = useState("");
    const [filters, setFilters] = useState({});
    const [sortConfig, setSortConfig] = useState({ key: "id", direction: "desc" });
    const [pageSize, setPageSize] = useState(DEFAULT_PAGE_SIZE);
    const [dashboard, setDashboard] = useState({ users: [], pets: [], appointments: [], orders: [], rechargePlans: [], products: [], services: [], appointmentServices: [], shops: [], groomers: [], recentAppointments: [], topServices: [], topProducts: [], recentActivities: [] });
    const [dashboardRange, setDashboardRange] = useState("30d");
    const [dashboardMetric, setDashboardMetric] = useState("revenue");
    const [dashboardLoading, setDashboardLoading] = useState(false);
    const [dashboardError, setDashboardError] = useState("");
    const [detailViewer, setDetailViewer] = useState({ open: false, record: null, menuId: null });
    const [editor, setEditor] = useState({ open: false, mode: "create", record: null });
    const [formData, setFormData] = useState({});
    const [saving, setSaving] = useState(false);
    const [success, setSuccess] = useState("");
    const [relationManager, setRelationManager] = useState({ open: false, operation: "", parent: null, rows: [], loading: false });
    const [relationEditor, setRelationEditor] = useState({ open: false, mode: "create", record: null });
    const [relationForm, setRelationForm] = useState({});
    const [lookups, setLookups] = useState({ shops: [], users: [], pets: [], groomers: [], servicePrices: [], services: [], appointmentServices: [], addresses: [] });
    const [lookupLoading, setLookupLoading] = useState(false);
    const [fieldErrors, setFieldErrors] = useState({});
    const [toasts, setToasts] = useState([]);
    const [confirmDialog, setConfirmDialog] = useState({ open: false, title: "Confirm action", message: "", danger: false });
    const confirmResolver = useRef(null);

    const showToast = (type, message) => {
        if (!message) return;
        const id = Date.now() + Math.random();
        setToasts((items) => [...items, { id, type, message }]);
        window.setTimeout(() => setToasts((items) => items.filter((item) => item.id !== id)), 3600);
    };

    const requestConfirm = (message, options = {}) => new Promise((resolve) => {
        confirmResolver.current = resolve;
        setConfirmDialog({ open: true, title: options.title || "Confirm action", message, danger: options.danger !== false });
    });

    const closeConfirm = (accepted) => {
        setConfirmDialog((prev) => ({ ...prev, open: false }));
        if (confirmResolver.current) confirmResolver.current(accepted);
        confirmResolver.current = null;
    };

    useEffect(() => { if (success) showToast("success", success); }, [success]);
    useEffect(() => { if (error) showToast("error", error); }, [error]);


    const roleNumber = Number(userrole);
    const allowedMenuIds = ROLE_ACCESS[roleNumber] || [0];
    const visibleMenus = menuList.filter((item) => allowedMenuIds.includes(item.id));
    const isAdmin = roleNumber === 0;
    const canAccessMenu = (menuId) => allowedMenuIds.includes(menuId);
    const canRunOperation = (operation) => isAdmin || !ADMIN_ONLY_OPERATIONS.has(operation);
    const toggleSidebar = () => {
        if (window.innerWidth <= 900) { setMobileSidebarOpen((open) => !open); return; }
        setSidebarCollapsed((collapsed) => { const next = !collapsed; localStorage.setItem("sidebarCollapsed", next ? "1" : "0"); return next; });
    };

    const currentMenu = menuList.find((item) => item.id === activeMenu);
    const config = configs[activeMenu];


    const loadLookups = async () => {
        setLookupLoading(true);

        const endpoints = {
            shops: "/shops",
            users: "/users",
            pets: "/pets",
            groomers: "/groomers",
            servicePrices: "/service-prices",
            services: "/services",
            appointmentServices: "/appointment-services",
            addresses: "/addresses",
        };

        try {
            const entries = Object.entries(endpoints);

            const results = await Promise.allSettled(
                entries.map(([, endpoint]) => api.get(endpoint))
            );

            const next = {};

            entries.forEach(([key], index) => {
                const result = results[index];

                if (
                    result.status === "fulfilled" &&
                    Array.isArray(result.value.data)
                ) {
                    next[key] = result.value.data;
                } else {
                    next[key] = [];
                }
            });

            setLookups(next);
        } catch (err) {
            console.error("Unable to load lookup data:", err);
        } finally {
            setLookupLoading(false);
        }
    };

    const lookupOptions = (lookup, fieldKey) => {
        let rows = lookups[lookup] || [];
        if (lookup === "pets" && formData.userId) rows = rows.filter((row) => Number(row.userId) === Number(formData.userId));
        if (lookup === "groomers" && formData.shopId) rows = rows.filter((row) => Number(row.shopId) === Number(formData.shopId));
        if (lookup === "addresses" && formData.userId) rows = rows.filter((row) => !row.userId || Number(row.userId) === Number(formData.userId));
        if (lookup === "servicePrices" && relationManager.operation === "Services") return rows;
        return rows;
    };

    const lookupLabel = (lookup, row) => {
        if (lookup === "users") return `${row.firstName || row.first_name || ""} ${row.lastName || row.last_name || ""}`.trim() || row.username || row.email || `User #${row.id}`;
        if (lookup === "shops") return row.name || `Shop #${row.id}`;
        if (lookup === "pets") return `${row.name || "Pet"}${row.category === 0 ? " (Dog)" : row.category === 1 ? " (Cat)" : ""}`;
        if (lookup === "groomers") return row.name || `Groomer #${row.id}`;
        if (lookup === "services") return row.name || `Service #${row.id}`;
        if (lookup === "servicePrices") {
            const service = lookups.services.find((item) => Number(item.id) === Number(row.serviceId));
            return `${service?.name || `Service #${row.serviceId}`} — $${row.price ?? "-"} / ${row.duration ?? "-"}`;
        }
        if (lookup === "addresses") return row.address || row.fullAddress || row.name || `Address #${row.id}`;
        return row.name || `#${row.id}`;
    };

    const filterDefinitions = useMemo(() => ({
        2: [{ key: "shopId", label: "Shop", type: "lookup", lookup: "shops" }, { key: "_type", label: "Groomer Type", options: [[0, "Senior Groomer"], [1, "Groomer"]] }],
        3: [{ key: "activationStatus", label: "Status", options: [[1, "Active"], [0, "Inactive"]] }],
        4: [{ key: "category", label: "Category", options: [[0, "General"], [1, "Dog Food"], [2, "Cat Food"], [3, "Other"]] }, { key: "_type", label: "Product Type", options: [[0, "Pet Food"], [1, "Snacks"], [2, "Toy & Bowl"], [3, "Clothes & Nook"], [4, "Daily Necessities"], [5, "Health & Medicine"], [6, "Other"]] }],
        5: [{ key: "category", label: "Pet Category", options: [[0, "Dog"], [1, "Cat"]] }, { key: "_type", label: "Service Type", options: [[0, "Washing"], [1, "Grooming"], [2, "SPA"]] }],
        6: [{ key: "appointmentStatus", label: "Appointment Status", options: [[0, "Pending Payment"], [1, "Confirmed"], [2, "Completed"], [3, "Cancelled"], [4, "Expired"]] }, { key: "paymentStatus", label: "Payment Status", options: [[0, "Pending"], [1, "Paid"], [2, "Failed"], [3, "Cancelled"], [4, "Refunded"]] }, { key: "shopId", label: "Shop", type: "lookup", lookup: "shops" }, { key: "groomerId", label: "Groomer", type: "lookup", lookup: "groomers" }, { key: "dateFrom", label: "From", type: "date" }, { key: "dateTo", label: "To", type: "date" }],
        7: [{ key: "role", label: "Role", options: [[0, "Administrator"], [1, "Shop Manager"], [2, "Customer"]] }, { key: "shopId", label: "Shop", type: "lookup", lookup: "shops" }],
        8: [{ key: "category", label: "Pet Category", options: [[0, "Dog"], [1, "Cat"]] }, { key: "activation_status", label: "Activation", options: [[0, "Unverified"], [1, "Verified"]] }, { key: "gender", label: "Gender", options: [[0, "Male"], [1, "Female"]] }],
        9: [{ key: "orderStatus", label: "Order Status", options: [[0, "Pending"], [1, "Processing"], [2, "Completed"], [3, "Cancelled"]] }, { key: "paymentStatus", label: "Payment Status", options: [[0, "Pending"], [1, "Paid"], [2, "Failed"], [3, "Cancelled"], [4, "Refunded"]] }, { key: "dateFrom", label: "From", type: "date" }, { key: "dateTo", label: "To", type: "date" }],
    }), []);

    const filteredData = useMemo(() => {
        const keyword = searchValue.trim().toLowerCase();
        const definitions = filterDefinitions[activeMenu] || [];
        let rows = dataList.filter((row) => {
            if (keyword && !Object.values(row).some((value) => String(value ?? "").toLowerCase().includes(keyword))) return false;
            return definitions.every((definition) => {
                const selected = filters[definition.key];
                if (selected === undefined || selected === null || selected === "") return true;
                if (definition.key === "dateFrom" || definition.key === "dateTo") {
                    const raw = row.startAt || row.createdAt || row.created_at;
                    if (!raw) return false;
                    const rowDate = new Date(raw); const boundary = new Date(selected + "T00:00:00");
                    if (definition.key === "dateFrom") return rowDate >= boundary;
                    boundary.setHours(23, 59, 59, 999); return rowDate <= boundary;
                }
                const value = row[definition.key] ?? (definition.key === "_type" ? row.type : undefined);
                return String(value) === String(selected);
            });
        });
        const { key, direction } = sortConfig;
        return [...rows].sort((a, b) => {
            const av = key === "_type" ? a.type : a[key]; const bv = key === "_type" ? b.type : b[key];
            const an = Number(av), bn = Number(bv);
            let result;
            if (av == null) result = 1; else if (bv == null) result = -1;
            else if (!Number.isNaN(an) && !Number.isNaN(bn) && String(av).trim() !== "" && String(bv).trim() !== "") result = an - bn;
            else result = String(av).localeCompare(String(bv), undefined, { numeric: true, sensitivity: "base" });
            return direction === "asc" ? result : -result;
        });
    }, [dataList, searchValue, filters, sortConfig, activeMenu, filterDefinitions]);

    const totalPages = Math.max(1, Math.ceil(filteredData.length / pageSize));
    const safePage = Math.min(currentPage, totalPages);
    const currentList = filteredData.slice((safePage - 1) * pageSize, safePage * pageSize);
    const isAllSelected = currentList.length > 0 && currentList.every((item) => selectedIds.includes(item.id));

    const loadDashboard = async () => {
        setDashboardLoading(true);
        setDashboardError("");
        const endpoints = ["/users", "/pets", "/appointments", "/shop-orders", "/recharge-bonuses", "/products", "/services", "/appointment-services", "/shops", "/groomers"];
        try {
            const results = await Promise.allSettled(endpoints.map((endpoint) => api.get(endpoint)));
            const failed = results.filter((result) => result.status === "rejected").length;
            if (failed === results.length) throw new Error("All dashboard requests failed");
            const rows = (index) => results[index].status === "fulfilled" && Array.isArray(results[index].value.data) ? results[index].value.data : [];
            const users = rows(0), pets = rows(1), appointments = rows(2), orders = rows(3), rechargePlans = rows(4), products = rows(5), services = rows(6), appointmentServices = rows(7), shops = rows(8), groomers = rows(9);
            const recentAppointments = [...appointments].sort((a, b) => new Date(b.startAt || b.createdAt || 0) - new Date(a.startAt || a.createdAt || 0)).slice(0, 5).map((item) => ({ ...item, shopName: shops.find((x) => Number(x.id) === Number(item.shopId))?.name, groomerName: groomers.find((x) => Number(x.id) === Number(item.groomerId))?.name }));
            const serviceCounts = new Map();
            appointmentServices.forEach((item) => serviceCounts.set(Number(item.serviceId), (serviceCounts.get(Number(item.serviceId)) || 0) + 1));
            const topServices = [...serviceCounts.entries()].map(([id, count]) => ({ id, count, name: services.find((item) => Number(item.id) === id)?.name || `Service #${id}` })).sort((a, b) => b.count - a.count).slice(0, 5);
            const productCounts = new Map();
            orders.forEach((order) => {
                const items = order.products || order.items || order.orderProducts || [];
                if (Array.isArray(items)) items.forEach((item) => { const id = Number(item.productId ?? item.product_id ?? item.product?.id); if (id) productCounts.set(id, (productCounts.get(id) || 0) + Number(item.quantity || item.qty || 1)); });
            });
            const topProducts = [...productCounts.entries()].map(([id, count]) => ({ id, count, name: products.find((item) => Number(item.id) === id)?.name || `Product #${id}` })).sort((a, b) => b.count - a.count).slice(0, 5);
            const paidOrders = orders.filter((item) => Number(item.paymentStatus) === 1);
            const activityCandidates = [
                ...users.map((item) => ({ icon: "users", title: `User ${item.username || item.email || `#${item.id}`} registered`, at: item.createdAt || item.created_at })),
                ...appointments.map((item) => ({ icon: "calendar", title: `Appointment #${item.id} booked`, at: item.createdAt || item.created_at || item.startAt })),
                ...paidOrders.map((item) => ({ icon: "wallet", title: `Payment received for ${item.trackingNumber || `order #${item.id}`}`, at: item.updatedAt || item.updated_at || item.createdAt || item.created_at })),
                ...products.map((item) => ({ icon: "paw", title: `Product ${item.name || `#${item.id}`} added`, at: item.createdAt || item.created_at })),
            ].filter((item) => item.at).sort((a, b) => new Date(b.at) - new Date(a.at)).slice(0, 5);
            setDashboard({ users, pets, appointments, orders, rechargePlans, products, services, appointmentServices, shops, groomers, recentAppointments, topServices, topProducts, recentActivities: activityCandidates });
            if (failed) setDashboardError(`${failed} dashboard data source${failed > 1 ? "s" : ""} could not be loaded. Available data is shown.`);
        } catch (err) {
            console.error(err);
            setDashboardError("Unable to load dashboard data. Please check the API service and try again.");
        } finally { setDashboardLoading(false); }
    };

    const dashboardAnalytics = useMemo(() => {
        const now = new Date(); now.setHours(23, 59, 59, 999);
        let start = new Date(now); start.setHours(0, 0, 0, 0);
        if (dashboardRange === "7d") start.setDate(start.getDate() - 6);
        else if (dashboardRange === "30d") start.setDate(start.getDate() - 29);
        else { start = new Date(now.getFullYear(), now.getMonth(), 1); }
        const duration = now.getTime() - start.getTime() + 1;
        const previousEnd = new Date(start.getTime() - 1);
        const previousStart = new Date(previousEnd.getTime() - duration + 1);
        const dateOf = (item, preferred) => { const raw = preferred ? item[preferred] : (item.createdAt || item.created_at || item.startAt || item.time); return raw ? new Date(raw) : null; };
        const inPeriod = (item, from, to, preferred) => { const d = dateOf(item, preferred); return d && d >= from && d <= to; };
        const paid = dashboard.orders.filter((x) => Number(x.paymentStatus) === 1);
        const sumRevenue = (from, to) => paid.filter((x) => inPeriod(x, from, to)).reduce((sum, x) => sum + Number(x.totalPrice || 0), 0);
        const current = {
            users: dashboard.users.filter((x) => inPeriod(x, start, now)).length, pets: dashboard.pets.filter((x) => inPeriod(x, start, now)).length,
            appointments: dashboard.appointments.filter((x) => inPeriod(x, start, now, "startAt")).length, orders: dashboard.orders.filter((x) => inPeriod(x, start, now)).length, revenue: sumRevenue(start, now)
        };
        const previous = {
            users: dashboard.users.filter((x) => inPeriod(x, previousStart, previousEnd)).length, pets: dashboard.pets.filter((x) => inPeriod(x, previousStart, previousEnd)).length,
            appointments: dashboard.appointments.filter((x) => inPeriod(x, previousStart, previousEnd, "startAt")).length, orders: dashboard.orders.filter((x) => inPeriod(x, previousStart, previousEnd)).length, revenue: sumRevenue(previousStart, previousEnd)
        };
        const compare = (value, old) => old === 0 ? (value === 0 ? 0 : null) : ((value - old) / old) * 100;
        const points = []; const cursor = new Date(start);
        while (cursor <= now) { const day = new Date(cursor); const next = new Date(day); next.setDate(next.getDate() + 1); const dayOrders = dashboard.orders.filter((x) => inPeriod(x, day, new Date(next.getTime() - 1))); const dayAppointments = dashboard.appointments.filter((x) => inPeriod(x, day, new Date(next.getTime() - 1), "startAt")); points.push({ date: day, revenue: dayOrders.filter((x) => Number(x.paymentStatus) === 1).reduce((sum, x) => sum + Number(x.totalPrice || 0), 0), orders: dayOrders.length, appointments: dayAppointments.length }); cursor.setDate(cursor.getDate() + 1); }
        return { start, now, current, previous, comparisons: { users: compare(current.users, previous.users), pets: compare(current.pets, previous.pets), appointments: compare(current.appointments, previous.appointments), revenue: compare(current.revenue, previous.revenue) }, points };
    }, [dashboard, dashboardRange]);

    const relativeTime = (value) => {
        if (!value) return ""; const seconds = Math.max(0, Math.floor((Date.now() - new Date(value).getTime()) / 1000));
        if (seconds < 60) return `${seconds}s ago`; if (seconds < 3600) return `${Math.floor(seconds / 60)}m ago`; if (seconds < 86400) return `${Math.floor(seconds / 3600)}h ago`; return `${Math.floor(seconds / 86400)}d ago`;
    };

    const overviewPoints = useMemo(() => {
        const values = dashboardAnalytics.points.map((item) => Number(item[dashboardMetric] || 0)); const max = Math.max(...values, 1);
        return dashboardAnalytics.points.map((item, index) => ({ x: dashboardAnalytics.points.length <= 1 ? 0 : index * 720 / (dashboardAnalytics.points.length - 1), y: 230 - (Number(item[dashboardMetric] || 0) / max) * 190, ...item }));
    }, [dashboardAnalytics.points, dashboardMetric]);
    const overviewPath = overviewPoints.map((point, index) => `${index ? "L" : "M"}${point.x.toFixed(1)} ${point.y.toFixed(1)}`).join(" ");
    const dashboardRangeLabel = dashboardRange === "7d" ? "Last 7 Days" : dashboardRange === "30d" ? "Last 30 Days" : "This Month";
    const metricLabel = dashboardMetric === "revenue" ? "Paid revenue" : dashboardMetric === "orders" ? "Orders" : "Appointments";
    const comparisonText = (value) => value === null ? "New vs previous period" : `${value >= 0 ? "+" : ""}${value.toFixed(1)}% vs previous period`;
    const navigateFromDashboard = (menuId, nextFilters = {}) => { changeMenu(menuId); setFilters(nextFilters); };

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
        if (!canAccessMenu(menuId)) {
            showToast(
                "error",
                "You do not have permission to access this section."
            );
            return;
        }

        setAiPageOpen(false);

        setActiveMenu(menuId);
        setMobileSidebarOpen(false);
        setProfileMenuOpen(false);
        setSearchValue("");
        setFilters({});
        setSortConfig({
            key: "id",
            direction: "desc",
        });
        setCurrentPage(1);

        fetchData(menuId);

        if (menuId !== 0) {
            loadLookups();
        }
    };

    const updateFilter = (key, value) => { setFilters((prev) => ({ ...prev, [key]: value })); setCurrentPage(1); };
    const clearFilters = () => { setFilters({}); setSearchValue(""); setCurrentPage(1); };
    const toggleSort = (column) => {
        const key = column.dataIndex || (column.title === "Order Status" ? "orderStatus" : "id");
        setSortConfig((prev) => ({ key, direction: prev.key === key && prev.direction === "asc" ? "desc" : "asc" }));
        setCurrentPage(1);
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
                { key: "shopId", label: "Assigned Shop", type: "select", lookup: "shops", numeric: true }, { key: "name", label: "Groomer Name", type: "text" },
                { key: "_type", source: "_type", label: "Groomer Type", type: "choice", numeric: true, options: [{ value: 0, label: "Senior Groomer" }, { value: 1, label: "Groomer" }] }, { key: "experience", label: "Experience (Yr)", type: "number" },
                { key: "customers", label: "Served Customers", type: "number" }, { key: "description", label: "Description", type: "textarea" },
                ...(editor.mode === "create" ? [{ key: "avatar", label: "Avatar URL", type: "text" }, { key: "price", label: "Price", type: "number" }] : []),
            ],
            3: [
                { key: "name", label: "Recharge Plan Name", type: "text", placeholder: "e.g. Recharge $100 Get $10" },
                { key: "rechargeAmount", label: "Recharge Amount", type: "number", min: 0, step: 1 },
                { key: "giftAmount", label: "Gift Amount", type: "number", min: 0, step: 1 },
                { key: "activationStatus", label: "Activation Status", type: "choice", numeric: true, options: [{ value: 1, label: "Active" }, { value: 0, label: "Inactive" }] },
                { key: "sortOrder", label: "Sort Order", type: "number", min: 0, step: 1 },
            ],
            4: [
                { key: "category", label: "Product Category", type: "choice", numeric: true, options: [{ value: 0, label: "General" }, { value: 1, label: "Dog Food" }, { value: 2, label: "Cat Food" }, { value: 3, label: "Other" }] }, { key: "_type", source: "_type", label: "Product Type", type: "choice", numeric: true, options: [{ value: 0, label: "Pet Food" }, { value: 1, label: "Snacks" }, { value: 2, label: "Toy & Bowl" }, { value: 3, label: "Clothes & Nook" }, { value: 4, label: "Daily Necessities" }, { value: 5, label: "Health & Medicine" }, { value: 6, label: "Other" }] },
                { key: "name", label: "Product Name", type: "text" }, { key: "nameZh", source: "nameZh", label: "Chinese Name", type: "text" },
                { key: "description", label: "Description", type: "textarea" },
            ],
            5: [
                { key: "_type", source: "_type", label: "Service Type", type: "choice", numeric: true, options: [{ value: 0, label: "Washing" }, { value: 1, label: "Grooming" }, { value: 2, label: "SPA" }] }, { key: "name", label: "Service Name", type: "text" },
                { key: "image", label: "Image URL", type: "text" }, { key: "description", label: "Description", type: "textarea" },
            ],
            6: editor.mode === "create" ? [
                { key: "userId", label: "User", type: "select", lookup: "users", numeric: true }, { key: "petId", label: "Pet", type: "select", lookup: "pets", numeric: true },
                { key: "shopId", label: "Assigned Shop", type: "select", lookup: "shops", numeric: true }, { key: "groomerId", label: "Groomer", type: "select", lookup: "groomers", numeric: true },
                { key: "servicePriceIds", label: "Services / Prices", type: "multiselect", lookup: "servicePrices", numeric: true },
                { key: "startAt", label: "Start At (ISO 8601)", type: "datetime-local", date: true }, { key: "notes", label: "Notes", type: "textarea", optional: true },
            ] : [{ key: "notes", label: "Notes", type: "textarea", optional: true }],
            7: editor.mode === "create" ? [
                { key: "username", label: "Account", type: "text" }, { key: "password", label: "Password", type: "password" },
                { key: "role", label: "Role", type: "choice", numeric: true, options: [{ value: 0, label: "Administrator" }, { value: 1, label: "Shop Manager" }, { value: 2, label: "Customer" }] }, { key: "shopId", label: "Assigned Shop", type: "select", lookup: "shops", numeric: true }, { key: "avatar", label: "Avatar URL", type: "text" },
                { key: "mobile", label: "Mobile", type: "text" }, { key: "email", label: "Email", type: "email" },
                { key: "firstName", label: "First Name", type: "text" }, { key: "lastName", label: "Last Name", type: "text" }, { key: "balance", label: "Balance", type: "number" },
            ] : [
                { key: "username", label: "Account", type: "text", optional: true }, { key: "role", label: "Role", type: "choice", numeric: true, optional: true, options: [{ value: 0, label: "Administrator" }, { value: 1, label: "Shop Manager" }, { value: 2, label: "Customer" }] },
                { key: "shopId", source: "shopId", label: "Shop", type: "select", lookup: "shops", numeric: true, optional: true }, { key: "avatar", label: "Avatar URL", type: "text", optional: true },
                { key: "mobile", label: "Mobile", type: "text", optional: true }, { key: "email", label: "Email", type: "email", optional: true },
                { key: "firstName", source: "firstName", label: "First Name", type: "text", optional: true }, { key: "lastName", source: "lastName", label: "Last Name", type: "text", optional: true },
                { key: "balance", label: "Balance", type: "number", optional: true },
            ],
            8: [
                { key: "userId", label: "User", type: "select", lookup: "users", numeric: true }, { key: "avatar", label: "Avatar URL", type: "text" }, { key: "name", label: "Pet Name", type: "text" },
                { key: "gender", label: "Gender", type: "choice", numeric: true, options: [{ value: 0, label: "Male" }, { value: 1, label: "Female" }] }, { key: "category", label: "Pet Category", type: "choice", numeric: true, options: [{ value: 0, label: "Dog" }, { value: 1, label: "Cat" }] }, { key: "furType", source: "furType", label: "Fur Type", type: "choice", numeric: true, options: [{ value: 0, label: "Short Hair" }, { value: 1, label: "Long Hair" }] },
                { key: "birthday", label: "Birthday", type: "date" }, { key: "activationStatus", source: "activationStatus", label: "Activation Status", type: "choice", numeric: true, options: [{ value: 1, label: "Verified / Active" }, { value: 0, label: "Unverified / Inactive" }] },
            ],
            9: editor.mode === "create" ? [
                { key: "userId", label: "User", type: "select", lookup: "users", numeric: true }, { key: "addressId", label: "Address", type: "select", lookup: "addresses", numeric: true },
                { key: "products", label: "Products JSON", type: "textarea", json: true, placeholder: '[{"productId":1,"stockId":1,"quantity":1,"price":100}]' },
            ] : [
                { key: "userId", source: "userId", label: "User", type: "select", lookup: "users", numeric: true }, { key: "addressId", source: "addressId", label: "Address", type: "select", lookup: "addresses", numeric: true },
                { key: "time", label: "Time", type: "text" }, { key: "totalPrice", source: "totalPrice", label: "Total Price", type: "text" },
                { key: "paymentStatus", source: "paymentStatus", label: "Payment Status", type: "choice", numeric: true, options: [{ value: 0, label: "Pending" }, { value: 1, label: "Paid" }, { value: 2, label: "Failed" }, { value: 3, label: "Cancelled" }, { value: 4, label: "Refunded" }] }, { key: "orderStatus", source: "orderStatus", label: "Order Status", type: "choice", numeric: true, options: [{ value: 0, label: "Pending" }, { value: 1, label: "Processing" }, { value: 2, label: "Completed" }, { value: 3, label: "Cancelled" }] },
                { key: "trackingNumber", source: "trackingNumber", label: "Tracking Number", type: "text" },
            ],
        };
        return byMenu[activeMenu] || [];
    }, [activeMenu, editor.mode]);

    const openEditor = (mode, record = null) => {
        loadLookups();
        const initial = {};
        editableFields.forEach((field) => {
            initial[field.key] = record?.[field.source || field.key] ?? "";
        });
        if (activeMenu === 7 && record) {
            initial.name = `${record.first_name || ""} ${record.last_name || ""}`.trim() || record.name || "";
        }
        setFormData(initial);
        setFieldErrors({});
        setEditor({ open: true, mode, record });
        setError("");
        setSuccess("");
    };

    const handleAdd = () => {
        if (activeMenu === 0) return changeMenu(7);
        openEditor("create");
    };

    const buildPayload = () => {
        const payload = { ...formData };
        editableFields.forEach((field) => {
            if ((field.type === "number" || field.type === "choice" || field.numeric) && payload[field.key] !== "" && !Array.isArray(payload[field.key])) payload[field.key] = Number(payload[field.key]);
            if (field.type === "multiselect") payload[field.key] = (payload[field.key] || []).map(Number);
            if (field.array && typeof payload[field.key] === "string") payload[field.key] = payload[field.key].split(",").map((v) => Number(v.trim())).filter(Number.isFinite);
            if (field.json && typeof payload[field.key] === "string") payload[field.key] = JSON.parse(payload[field.key] || "[]");
            if (field.date && payload[field.key]) payload[field.key] = new Date(payload[field.key]).toISOString();
            if (field.optional && payload[field.key] === "") delete payload[field.key];
        });
        return payload;
    };

    const validateForm = () => {
        const errors = {};
        editableFields.forEach((field) => {
            const value = formData[field.key];
            const empty = value === "" || value === null || value === undefined || (Array.isArray(value) && value.length === 0);
            if (!field.optional && empty) errors[field.key] = `${field.label} is required.`;
            if (!empty && (field.type === "number" || field.numeric)) {
                const number = Number(value);
                if (!Number.isFinite(number)) errors[field.key] = `${field.label} must be a valid number.`;
                else if (field.min !== undefined && number < Number(field.min)) errors[field.key] = `${field.label} must be at least ${field.min}.`;
                else if (field.max !== undefined && number > Number(field.max)) errors[field.key] = `${field.label} must not exceed ${field.max}.`;
            }
            if (!empty && (field.key.toLowerCase().includes("email") || field.type === "email") && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(value))) errors[field.key] = "Enter a valid email address.";
            if (!empty && (field.key.toLowerCase().includes("mobile") || field.key.toLowerCase().includes("phone")) && !/^[+()\d\s-]{6,20}$/.test(String(value))) errors[field.key] = "Enter a valid phone number.";
            if (!empty && (field.key.toLowerCase().includes("url") || field.type === "url")) {
                try { new URL(String(value)); } catch { errors[field.key] = "Enter a valid URL."; }
            }
        });
        if (formData.dateFrom && formData.dateTo && new Date(formData.dateFrom) > new Date(formData.dateTo)) errors.dateTo = "End date must be after start date.";
        setFieldErrors(errors);
        if (Object.keys(errors).length) showToast("error", "Please correct the highlighted fields before saving.");
        return Object.keys(errors).length === 0;
    };

    const saveRecord = async (event) => {
        event.preventDefault();
        if (!config) return;
        if (!validateForm()) return;
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
        if (!(await requestConfirm(`Delete ${data.name || data.username || data.trackingNumber || data.id}? This action cannot be undone.`, { title: "Delete record" }))) return;
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
        if (!selectedIds.length) return showToast("info", "Please select data to delete first.");
        if (!(await requestConfirm(`Delete ${selectedIds.length} selected item(s)? This action cannot be undone.`, { title: "Delete selected records" }))) return;
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

    const loadRelationRows = async (operation, parent) => {
        loadLookups();
        const relation = relationConfigs[operation];
        if (!relation) return;
        setRelationManager({ open: true, operation, parent, rows: [], loading: true });
        setError("");
        try {
            const res = await api.get(relation.endpoint);
            const rows = (Array.isArray(res.data) ? res.data : []).filter((row) => Number(row[relation.parentKey]) === Number(parent.id));
            setRelationManager({ open: true, operation, parent, rows, loading: false });
        } catch (err) {
            setRelationManager({ open: true, operation, parent, rows: [], loading: false });
            setError(getErrorMessage(err, `Unable to load ${relation.title}.`));
        }
    };

    const openRelationEditor = (mode, record = null) => {
        const relation = relationConfigs[relationManager.operation];
        if (!relation) return;
        const initial = {};
        relation.fields.forEach((field) => { initial[field.key] = record?.[field.key] ?? ""; });
        setRelationForm(initial);
        setRelationEditor({ open: true, mode, record });
    };

    const saveRelation = async (event) => {
        event.preventDefault();
        const relation = relationConfigs[relationManager.operation];
        if (!relation) return;
        setSaving(true);
        try {
            const payload = { [relation.parentKey]: Number(relationManager.parent.id) };
            relation.fields.forEach((field) => {
                payload[field.key] = (field.type === "number" || field.numeric) ? Number(relationForm[field.key]) : relationForm[field.key];
            });
            if (relationEditor.mode === "create") await api.post(relation.endpoint, payload);
            else await api.put(`${relation.endpoint}/${relationEditor.record.id}`, payload);
            setRelationEditor({ open: false, mode: "create", record: null });
            setSuccess(`${relation.title} saved successfully.`);
            await loadRelationRows(relationManager.operation, relationManager.parent);
        } catch (err) {
            setError(getErrorMessage(err, `Unable to save ${relation.title}.`));
        } finally { setSaving(false); }
    };

    const deleteRelation = async (record) => {
        const relation = relationConfigs[relationManager.operation];
        if (!relation || !(await requestConfirm(`Delete #${record.id}? This action cannot be undone.`, { title: "Delete related record" }))) return;
        try {
            await api.delete(`${relation.endpoint}/${record.id}`);
            setSuccess(`${relation.title} item deleted successfully.`);
            await loadRelationRows(relationManager.operation, relationManager.parent);
        } catch (err) { setError(getErrorMessage(err, `Unable to delete ${relation.title} item.`)); }
    };

    const handleOperation = async (data, operation) => {
        if (!canRunOperation(operation)) { showToast("error", "This action requires administrator permission."); return; }
        if (operation === "View") setDetailViewer({ open: true, record: data, menuId: activeMenu });
        else if (operation === "Edit") openEditor("edit", data);
        else if (operation === "Delete") await deleteRecord(data);
        else if (operation === "Reset Password") {
            if (!(await requestConfirm(`Reset password for ${data.account || data.username || data.name || data.id}?`, { title: "Reset password", danger: false }))) return;
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
        } else if (operation === "Toggle Status") {
            const nextStatus = Number(data.activationStatus) === 1 ? 0 : 1;
            if (!(await requestConfirm(`${nextStatus ? "Activate" : "Deactivate"} ${data.name || `plan #${data.id}`}?`, { title: "Change recharge status", danger: false }))) return;
            try {
                await api.put(`/recharge-bonuses/${data.id}`, { name: data.name, rechargeAmount: Number(data.rechargeAmount), giftAmount: Number(data.giftAmount), activationStatus: nextStatus, sortOrder: Number(data.sortOrder) });
                setSuccess(`Recharge plan ${nextStatus ? "activated" : "deactivated"} successfully.`);
                await fetchData(activeMenu);
            } catch (err) { setError(getErrorMessage(err, "Unable to change recharge plan status.")); }
        } else if (operation === "Complete") {
            if (Number(data.appointmentStatus) !== 1) return;
            if (!(await requestConfirm("Mark this confirmed booking as completed?", { title: "Complete booking", danger: false }))) return;
            try { await api.put(`/appointments/${data.id}/complete`); setSuccess("Booking completed successfully."); await fetchData(activeMenu); }
            catch (err) { setError(getErrorMessage(err, "Unable to complete booking.")); }
        } else if (operation === "Cancel") {
            if (![0, 1].includes(Number(data.appointmentStatus))) return;
            if (!(await requestConfirm("Cancel this booking?", { title: "Cancel booking" }))) return;
            try { await api.put(`/appointments/${data.id}/cancel`, {}, { headers: { "x-user-id": String(data.userId) } }); setSuccess("Booking cancelled successfully."); await fetchData(activeMenu); }
            catch (err) { setError(getErrorMessage(err, "Unable to cancel booking.")); }
        } else if (operation === "Next Step") goToNextStep(data);
        else if (relationConfigs[operation]) await loadRelationRows(operation, data);
        else showToast("info", `${operation}: ${data.name || data.id}`);
    };

    const goToNextStep = async (data) => {
        if (Number(data.paymentStatus) !== 1 || ![0, 1].includes(Number(data.orderStatus))) return;
        const nextLabel = Number(data.orderStatus) === 0 ? "Processing" : "Completed";
        if (!(await requestConfirm(`Move order ${data.trackingNumber || `#${data.id}`} to ${nextLabel}?`, { title: "Update order status", danger: false }))) return;
        setError("");
        setLoading(true);
        try {
            await api.post(`/shop-orders/process/${data.id}`);
            setSuccess(`Order moved to ${nextLabel}.`);
            await fetchData(activeMenu);
        } catch (err) {
            console.error(err);
            setDataList([]);
            setError(getErrorMessage(err, "Unable to process order."));
        } finally {
            setLoading(false);
        }
    }

    const statCards = [
        { label: "New Users", value: dashboardAnalytics.current.users.toLocaleString(), detail: comparisonText(dashboardAnalytics.comparisons.users), icon: "users", menuId: 7 },
        { label: "New Pets", value: dashboardAnalytics.current.pets.toLocaleString(), detail: comparisonText(dashboardAnalytics.comparisons.pets), icon: "paw", menuId: 8 },
        { label: "Appointments", value: dashboardAnalytics.current.appointments.toLocaleString(), detail: comparisonText(dashboardAnalytics.comparisons.appointments), icon: "calendar", menuId: 6, filters: { dateFrom: dashboardAnalytics.start.toISOString().slice(0, 10), dateTo: dashboardAnalytics.now.toISOString().slice(0, 10) } },
        { label: "Paid Revenue", value: `$${Number(dashboardAnalytics.current.revenue).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`, detail: comparisonText(dashboardAnalytics.comparisons.revenue), icon: "wallet", menuId: 9, filters: { paymentStatus: 1, dateFrom: dashboardAnalytics.start.toISOString().slice(0, 10), dateTo: dashboardAnalytics.now.toISOString().slice(0, 10) } },
    ];

    return (
        <div className={`management-layout ${sidebarCollapsed ? "sidebar-collapsed" : ""}`}>
            {mobileSidebarOpen && <button className="mobile-sidebar-overlay" type="button" aria-label="Close navigation" onClick={() => setMobileSidebarOpen(false)} />}
            <aside className={`sidebar ${mobileSidebarOpen ? "mobile-open" : ""}`}>
                <div className="sidebar-logo">
                    <img className="sidebar-logo-img" src={logo} alt="YiPet" />
                    <div className="brand-copy"><strong>YiPet</strong><span>Admin</span></div>
                </div>
                <nav className="sidebar-menu">
                    {visibleMenus.map((menu) => (
                        <button key={menu.id} type="button" className={`sidebar-menu-item ${activeMenu === menu.id ? "active" : ""}`} onClick={() => changeMenu(menu.id)} title={sidebarCollapsed ? menu.name : undefined}>
                            {menu.iconName ? <Icon name={menu.iconName} size={19} /> : <img className="menu-icon" src={activeMenu === menu.id ? menu.selected : menu.unselect} alt="" />}
                            <span>{menu.name}</span>
                        </button>
                    ))}
                </nav>
                <div className="sidebar-footer">
                    <div className="profile-card-wrap">
                        <button className="profile-card" type="button" onClick={() => setProfileMenuOpen((open) => !open)} aria-expanded={profileMenuOpen}>
                            <img src={avatar} alt="User avatar" />
                            <div><strong>{username || "Admin"}</strong><span>{isAdmin ? "Administrator" : "Manager"}</span></div>
                            <span className="profile-chevron">⌄</span>
                        </button>
                        {profileMenuOpen && <div className="profile-menu">
                            <div className="profile-menu-head"><Icon name="user" size={17} /><div><strong>{username || "Admin"}</strong><span>{isAdmin ? "Full administrator access" : "Operational manager access"}</span></div></div>
                            <button type="button" onClick={() => { setProfileMenuOpen(false); changeMenu(0); }}><Icon name="dashboard" size={16} />Dashboard</button>
                            <button type="button" className="logout-menu-item" onClick={async () => { setProfileMenuOpen(false); if (await requestConfirm("Sign out of YiPet Admin?", { title: "Sign out", danger: false })) onLogout(); }}><Icon name="logout" size={16} />Sign out</button>
                        </div>}
                    </div>
                    <div className={`ai-card ${aiPageOpen ? "active" : ""}`}>
                        <div className="ai-copy">
                            <strong>
                                YiPet AI
                                <br />
                                Assistant
                            </strong>

                            <span>
                                Smart support for your
                                <br />
                                YiPet platform
                            </span>

                            <button
                                type="button"
                                onClick={() => {
                                    setAiPageOpen(true);
                                    setMobileSidebarOpen(false);
                                    setProfileMenuOpen(false);
                                }}
                            >
                                {aiPageOpen ? "AI Chat →" : "Try Now →"}
                            </button>
                        </div>

                        <div className="ai-robot">
                            🤖
                        </div>
                    </div>
                </div>
            </aside>
            <main className="main-area">
                <header className="top-header">
                    <button className="header-icon-button" type="button" aria-label="Toggle navigation" onClick={toggleSidebar}><Icon name="menu" /></button>
                </header>
                {aiPageOpen ? (
                    <AIChat
                        username={username}
                        onClose={() => setAiPageOpen(false)}
                    />
                ) : activeMenu === 0 ? (
                    <section className="dashboard-content">
                        <div className="welcome-banner">
                            <div><h1>Welcome back, {username || "Admin"}! <span>👋</span></h1><p>Here’s what’s happening with your YiPet platform today.</p></div>
                            <div className="pet-scene" aria-hidden="true"><span className="leaf leaf-a">●</span><span className="pet-dog">🐶</span><span className="pet-cat">🐱</span><span className="leaf leaf-b">●</span></div>
                        </div>
                        {dashboardError && <div className="dashboard-alert"><span>{dashboardError}</span><button type="button" onClick={loadDashboard}>Retry</button></div>}
                        <div className="dashboard-range-bar"><div><strong>Analytics period</strong><span>{dashboardRangeLabel}</span></div><div className="range-buttons"><button className={dashboardRange === "7d" ? "active" : ""} onClick={() => setDashboardRange("7d")} type="button">7 Days</button><button className={dashboardRange === "30d" ? "active" : ""} onClick={() => setDashboardRange("30d")} type="button">30 Days</button><button className={dashboardRange === "month" ? "active" : ""} onClick={() => setDashboardRange("month")} type="button">This Month</button><button type="button" className="refresh-dashboard" onClick={loadDashboard} disabled={dashboardLoading}>{dashboardLoading ? "Refreshing…" : "Refresh"}</button></div></div>
                        {dashboardLoading && dashboard.users.length === 0 ? <div className="dashboard-skeleton"><div className="skeleton-banner" /><div className="skeleton-card-grid">{Array.from({ length: 4 }).map((_, i) => <div className="skeleton-card" key={i} />)}</div><div className="skeleton-panel-grid"><div /><div /><div /></div></div> : <>
                            <div className="stat-grid">
                                {statCards.map((card) => <button type="button" className="stat-card stat-card-button" key={card.label} onClick={() => navigateFromDashboard(card.menuId, card.filters || {})}><div className="stat-icon"><Icon name={card.icon} size={26} /></div><div><span className="stat-label">{card.label}</span><strong>{card.value}</strong><small>{card.detail}</small></div><span className="stat-arrow">→</span></button>)}
                            </div>
                            <div className="dashboard-grid">
                                <article className="panel overview-panel">
                                    <div className="panel-head dashboard-overview-head"><h3>Overview</h3><div className="dashboard-controls"><select value={dashboardMetric} onChange={(e) => setDashboardMetric(e.target.value)}><option value="revenue">Revenue</option><option value="orders">Orders</option><option value="appointments">Appointments</option></select><select value={dashboardRange} onChange={(e) => setDashboardRange(e.target.value)}><option value="7d">Last 7 Days</option><option value="30d">Last 30 Days</option><option value="month">This Month</option></select></div></div>
                                    <div className="chart-wrap real-chart">
                                        <svg viewBox="0 0 720 250" preserveAspectRatio="none" className="line-chart" aria-label={`${metricLabel} — ${dashboardRangeLabel}`}><path className="grid-line" d="M0 40H720M0 100H720M0 160H720M0 220H720" />{overviewPath && <><path className="area" d={`${overviewPath} L720 240 L0 240 Z`} /><path className="trend" d={overviewPath} /></>}</svg>
                                        <div className="x-axis"><span>{dashboardAnalytics.points[0]?.date?.toLocaleDateString(undefined, { month: "short", day: "numeric" }) || "-"}</span><span>{dashboardRangeLabel} · {metricLabel}</span><span>{dashboardAnalytics.points.at(-1)?.date?.toLocaleDateString(undefined, { month: "short", day: "numeric" }) || "-"}</span></div>
                                    </div>
                                </article>
                                <article className="panel services-panel"><div className="panel-head"><h3>Top Services</h3><span>Bookings</span></div><div className="rank-list">{dashboard.topServices.length ? dashboard.topServices.map((item, index) => <div className="rank-item" key={item.id}><b>{index + 1}</b><span>{item.name}</span><strong>{item.count}</strong></div>) : <div className="dashboard-empty">No service usage data.</div>}</div><button className="view-link" type="button" onClick={() => changeMenu(5)}>View all services →</button></article>
                                <article className="panel activities-panel"><div className="panel-head"><h3>Recent Activities</h3></div><div className="activity-list">{dashboard.recentActivities.length ? dashboard.recentActivities.map((item, index) => <div className="activity-item" key={`${item.title}-${index}`}><span className="activity-icon"><Icon name={item.icon} size={17} /></span><div><strong>{item.title}</strong><small>{relativeTime(item.at)}</small></div></div>) : <div className="dashboard-empty">No recent activity data.</div>}</div></article>
                                <article className="panel appointments-panel"><div className="panel-head"><h3>Recent Appointments</h3></div><div className="mini-table"><div className="mini-row mini-head"><span>ID</span><span>Shop</span><span>Groomer</span><span>Time</span><span>Status</span></div>{dashboard.recentAppointments.length ? dashboard.recentAppointments.map((item) => <div className="mini-row" key={item.id}><span><b className="pet-avatar">{String(item.id).slice(-1)}</b>#{item.id}</span><span>{item.shopName || `#${item.shopId ?? "-"}`}</span><span>{item.groomerName || `#${item.groomerId ?? "-"}`}</span><span>{item.startAt ? new Date(item.startAt).toLocaleString() : "-"}</span><span><StatusBadge label={appointmentStatusLabel(item.appointmentStatus)} /></span></div>) : <div className="dashboard-empty">No appointment data.</div>}</div><button className="view-link" type="button" onClick={() => changeMenu(6)}>View all appointments →</button></article>
                                <article className="panel products-panel"><div className="panel-head"><h3>Top Products</h3><span>Qty</span></div><div className="product-list">{dashboard.topProducts.length ? dashboard.topProducts.map((item) => <div key={item.id}><span className="product-emoji">📦</span><strong>{item.name}</strong><span>{item.count}</span></div>) : <div className="dashboard-empty">Order responses do not contain product-line data yet.</div>}</div><button className="view-link" type="button" onClick={() => changeMenu(4)}>View all products →</button></article>
                            </div>
                        </>}
                    </section>
                ) : (
                    <section className="content-section">
                        <div className="page-heading-row"><div><h1>{currentMenu?.name}</h1><p>Manage your YiPet {currentMenu?.name.toLowerCase()} data.</p></div><div className="table-actions">{isAdmin && <button className="outline-danger" type="button" onClick={handleBatchDelete}><Icon name="trash" size={17} />Batch Delete</button>}<button className="primary-button" type="button" onClick={handleAdd}><Icon name="plus" size={17} />Add New</button></div></div>
                        <div className="data-card">
                            {error && <div className="error-message">{error}</div>}
                            {success && <div className="success-message">{success}</div>}
                            <div className="management-toolbar">
                                <label className="management-search"><Icon name="search" size={17} /><input value={searchValue} onChange={(e) => { setSearchValue(e.target.value); setCurrentPage(1); }} placeholder={`Search ${currentMenu?.name.replace(" Management", "").toLowerCase()}...`} /></label>
                                {(filterDefinitions[activeMenu] || []).map((filter) => filter.type === "date" ? <label className="filter-date" key={filter.key}><span>{filter.label}</span><input type="date" value={filters[filter.key] || ""} onChange={(e) => updateFilter(filter.key, e.target.value)} /></label> : <select key={filter.key} value={filters[filter.key] ?? ""} onChange={(e) => updateFilter(filter.key, e.target.value)}><option value="">All {filter.label}</option>{filter.type === "lookup" ? lookupOptions(filter.lookup, filter.key).map((row) => <option key={row.id} value={row.id}>{lookupLabel(filter.lookup, row)}</option>) : filter.options?.map(([value, label]) => <option key={value} value={value}>{label}</option>)}</select>)}
                                {(searchValue || Object.values(filters).some((value) => value !== "" && value != null)) && <button type="button" className="clear-filter-button" onClick={clearFilters}>Clear filters</button>}
                                <span className="filter-result-count">{filteredData.length} results</span>
                            </div>
                            <div className="table-wrapper">
                                <table className="store-table">
                                    <thead><tr><th className="checkbox-column"><input type="checkbox" checked={isAllSelected} onChange={handleSelectAll} /></th>{config?.columns.map((column) => { const sortKey = column.dataIndex || (column.title === "Order Status" ? "orderStatus" : "id"); return <th key={`${column.title}-${column.dataIndex}`} style={{ width: column.width }}><button className="sort-header" type="button" onClick={() => toggleSort(column)}>{column.title}<span>{sortConfig.key === sortKey ? (sortConfig.direction === "asc" ? "↑" : "↓") : "↕"}</span></button></th>; })}<th className="operation-column">Operate</th></tr></thead>
                                    <tbody>
                                        {loading ? Array.from({ length: 6 }).map((_, rowIndex) => <tr className="skeleton-row" key={`skeleton-${rowIndex}`}><td colSpan={(config?.columns.length || 0) + 2}><span className="skeleton-line" style={{ width: `${72 + (rowIndex % 3) * 8}%` }} /></td></tr>) : currentList.length ? currentList.map((data) => <tr key={data.id}><td className="checkbox-column"><input type="checkbox" checked={selectedIds.includes(data.id)} onChange={() => handleSelectOne(data.id)} /></td>{config.columns.map((column) => <td key={column.dataIndex}>{["avatar", "image"].includes(column.dataIndex) && data[column.dataIndex] ? <img className="column-img" src={data[column.dataIndex]} alt="" /> : formatValue(data, column, currentMenu?.id, lookups)}</td>)}<td><div className="operation-buttons">{config.operations.filter(canRunOperation).map((operation) => { if (operation === "Activate" && data.activation_status !== 0) return null; if (operation === "Complete" && Number(data.appointmentStatus) !== 1) return null; if (operation === "Cancel" && ![0, 1].includes(Number(data.appointmentStatus))) return null; if (operation === "Next Step" && (Number(data.paymentStatus) !== 1 || ![0, 1].includes(Number(data.orderStatus)))) return null; const label = operation === "Toggle Status" ? (Number(data.activationStatus) === 1 ? "Deactivate" : "Activate") : operation === "Next Step" ? (Number(data.orderStatus) === 0 ? "Start Processing" : "Complete Order") : operation; return <button key={operation} type="button" className={operation === "Edit" ? "edit-button" : operation === "Delete" || operation === "Cancel" || label === "Deactivate" ? "delete-button" : operation === "Images" || operation === "Prices" || operation === "Services" ? "images-button" : operation === "Size" || operation === "Activate" || label === "Activate" || operation === "Complete" ? "activate-button" : "default-button"} onClick={() => handleOperation(data, operation)}>{operation === "Edit" && <Icon name="edit" size={14} />} {label}</button>; })}</div></td></tr>) : <tr><td colSpan={(config?.columns.length || 0) + 2} className="empty-table">{config?.empty}</td></tr>}
                                    </tbody>
                                </table>
                            </div>
                            <div className="pagination"><span>{filteredData.length} items</span><label className="page-size-select">Rows <select value={pageSize} onChange={(e) => { setPageSize(Number(e.target.value)); setCurrentPage(1); }}><option value={10}>10</option><option value={20}>20</option><option value={50}>50</option></select></label><div><button type="button" onClick={() => setCurrentPage((p) => Math.max(1, p - 1))} disabled={safePage === 1}>‹</button><span>{safePage}</span><button type="button" onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))} disabled={safePage === totalPages}>›</button></div><span>Page {safePage} of {totalPages}</span></div>
                        </div>
                    </section>
                )}
            </main>
            {relationManager.open && (() => {
                const relation = relationConfigs[relationManager.operation];
                return relation && (
                    <div className="crud-modal-backdrop" role="presentation">
                        <section className="crud-modal relation-modal" role="dialog" aria-modal="true">
                            <div className="crud-modal-head">
                                <div><span>Related Data</span><h2>{relation.title} — {relationManager.parent?.name || `#${relationManager.parent?.id}`}</h2></div>
                                <button type="button" onClick={() => { setRelationManager({ open: false, operation: "", parent: null, rows: [], loading: false }); setRelationEditor({ open: false, mode: "create", record: null }); }}>×</button>
                            </div>
                            <div className="relation-toolbar"><button className="primary-button" type="button" onClick={() => openRelationEditor("create")}>+ Add New</button></div>
                            {relationEditor.open && <form className="relation-form" onSubmit={saveRelation}><div className="crud-form-grid">{relation.fields.map((field) => <label key={field.key}><span>{field.label}</span>{field.type === "select" ? <select required value={relationForm[field.key] ?? ""} onChange={(e) => setRelationForm((prev) => ({ ...prev, [field.key]: e.target.value }))}><option value="">Select {field.label}</option>{lookupOptions(field.lookup, field.key).map((row) => <option key={row.id} value={row.id}>{lookupLabel(field.lookup, row)}</option>)}</select> : <input required type={field.type} value={relationForm[field.key] ?? ""} onChange={(e) => setRelationForm((prev) => ({ ...prev, [field.key]: e.target.value }))} />}</label>)}</div><div className="crud-modal-actions"><button className="crud-cancel" type="button" onClick={() => setRelationEditor({ open: false, mode: "create", record: null })}>Cancel</button><button className="primary-button" disabled={saving}>{saving ? "Saving..." : relationEditor.mode === "create" ? "Create" : "Save Changes"}</button></div></form>}
                            <div className="table-wrapper"><table className="store-table"><thead><tr>{relation.columns.map((column) => <th key={column}>{column}</th>)}<th>Operate</th></tr></thead><tbody>{relationManager.loading ? <tr><td colSpan={relation.columns.length + 1} className="empty-table">Loading...</td></tr> : relationManager.rows.length ? relationManager.rows.map((row) => <tr key={row.id}>{relation.columns.map((column) => <td key={column}>{column === "url" && row[column] ? <img className="column-img" src={row[column]} alt="" /> : String(row[column] ?? "-")}</td>)}<td><div className="operation-buttons"><button className="edit-button" type="button" onClick={() => openRelationEditor("edit", row)}>Edit</button>{isAdmin && <button className="delete-button" type="button" onClick={() => deleteRelation(row)}>Delete</button>}</div></td></tr>) : <tr><td colSpan={relation.columns.length + 1} className="empty-table">No related data currently.</td></tr>}</tbody></table></div>
                        </section>
                    </div>
                );
            })()}
            <div className="toast-stack" aria-live="polite" aria-atomic="true">
                {toasts.map((toast) => <div key={toast.id} className={`toast toast-${toast.type}`}><span className="toast-mark">{toast.type === "success" ? "✓" : toast.type === "error" ? "!" : "i"}</span><span>{toast.message}</span><button type="button" onClick={() => setToasts((items) => items.filter((item) => item.id !== toast.id))}>×</button></div>)}
            </div>
            {confirmDialog.open && <div className="crud-modal-backdrop confirm-backdrop" role="presentation"><section className="confirm-dialog" role="alertdialog" aria-modal="true"><div className={`confirm-icon ${confirmDialog.danger ? "danger" : "neutral"}`}>{confirmDialog.danger ? "!" : "?"}</div><h3>{confirmDialog.title}</h3><p>{confirmDialog.message}</p><div className="confirm-actions"><button type="button" className="crud-cancel" onClick={() => closeConfirm(false)}>Cancel</button><button type="button" className={confirmDialog.danger ? "danger-confirm" : "primary-button"} onClick={() => closeConfirm(true)}>{confirmDialog.danger ? "Confirm" : "Continue"}</button></div></section></div>}
            {detailViewer.open && detailViewer.record && (
                <div className="crud-modal-backdrop" role="presentation" onMouseDown={(event) => event.target === event.currentTarget && setDetailViewer({ open: false, record: null, menuId: null })}>
                    <section className="crud-modal detail-modal" role="dialog" aria-modal="true" aria-label="Record details">
                        <div className="crud-modal-head"><div><span>View Details</span><h2>{menuList.find((item) => item.id === detailViewer.menuId)?.name}</h2></div><button type="button" onClick={() => setDetailViewer({ open: false, record: null, menuId: null })}>×</button></div>
                        <div className="detail-grid">
                            {Object.entries(detailViewer.record)
                                .filter(([key]) => !["password"].includes(key))
                                .map(([key, value]) => (
                                    <div className="detail-field" key={key}>
                                        <span>
                                            {formatDetailLabel(
                                                key,
                                                detailViewer.menuId
                                            )}
                                        </span>

                                        <strong>
                                            {formatDetailValue(
                                                key,
                                                value,
                                                detailViewer.menuId
                                            )}
                                        </strong>
                                    </div>
                                ))}
                        </div>
                        <div className="crud-modal-actions detail-actions"><button type="button" className="crud-cancel" onClick={() => setDetailViewer({ open: false, record: null, menuId: null })}>Close</button><button type="button" className="primary-button" onClick={() => { const record = detailViewer.record; setDetailViewer({ open: false, record: null, menuId: null }); openEditor("edit", record); }}>Edit Record</button></div>
                    </section>
                </div>
            )}
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
                                    <label key={field.key} className={`${field.type === "textarea" ? "full-width" : ""} ${fieldErrors[field.key] ? "field-invalid" : ""}`}>
                                        <span>{field.label}</span>
                                        {field.type === "textarea" ? (
                                            <textarea required={!field.optional} placeholder={field.placeholder || ""} value={formData[field.key] ?? ""} onChange={(event) => setFormData((prev) => ({ ...prev, [field.key]: event.target.value }))} rows="4" />
                                        ) : field.type === "choice" ? (
                                            <select required={!field.optional} value={formData[field.key] ?? ""} onChange={(event) => setFormData((prev) => ({ ...prev, [field.key]: event.target.value }))}><option value="">Select {field.label}</option>{(field.options || []).map((option) => <option key={option.value} value={option.value}>{option.label}</option>)}</select>
                                        ) : field.type === "select" ? (
                                            <select required={!field.optional} value={formData[field.key] ?? ""} disabled={lookupLoading} onChange={(event) => setFormData((prev) => ({ ...prev, [field.key]: event.target.value, ...(field.key === "userId" ? { petId: "", addressId: "" } : {}), ...(field.key === "shopId" ? { groomerId: "" } : {}) }))}><option value="">{lookupLoading ? "Loading..." : `Select ${field.label}`}</option>{lookupOptions(field.lookup, field.key).map((row) => <option key={row.id} value={row.id}>{lookupLabel(field.lookup, row)}</option>)}</select>
                                        ) : field.type === "multiselect" ? (
                                            <select multiple required={!field.optional} value={Array.isArray(formData[field.key]) ? formData[field.key].map(String) : []} disabled={lookupLoading} onChange={(event) => setFormData((prev) => ({ ...prev, [field.key]: Array.from(event.target.selectedOptions, (option) => Number(option.value)) }))}>{lookupOptions(field.lookup, field.key).map((row) => <option key={row.id} value={row.id}>{lookupLabel(field.lookup, row)}</option>)}</select>
                                        ) : (
                                            <input required={!field.optional} type={field.type} min={field.min} max={field.max} step={field.step} placeholder={field.placeholder || ""} value={formData[field.key] ?? ""} onChange={(event) => setFormData((prev) => ({ ...prev, [field.key]: event.target.value }))} />
                                        )}
                                        {fieldErrors[field.key] && <small className="field-error">{fieldErrors[field.key]}</small>}
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

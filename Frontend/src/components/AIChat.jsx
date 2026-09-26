import api, { getErrorMessage } from "../api";
import { useEffect, useMemo, useRef, useState } from "react";
import "../css/aiChat.css";

const Icon = ({ name, size = 20 }) => {
    const icons = {
        plus: (
            <>
                <path d="M12 5v14M5 12h14" />
            </>
        ),
        send: (
            <>
                <path d="m22 2-7 20-4-9-9-4Z" />
                <path d="M22 2 11 13" />
            </>
        ),
        message: (
            <>
                <path d="M21 15a4 4 0 0 1-4 4H8l-5 3V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4Z" />
            </>
        ),
        trash: (
            <>
                <path d="M3 6h18" />
                <path d="M8 6V4h8v2" />
                <path d="m19 6-1 15H6L5 6" />
                <path d="M10 11v6M14 11v6" />
            </>
        ),
        sparkles: (
            <>
                <path d="m12 3 1.3 3.7L17 8l-3.7 1.3L12 13l-1.3-3.7L7 8l3.7-1.3Z" />
                <path d="m19 14 .8 2.2L22 17l-2.2.8L19 20l-.8-2.2L16 17l2.2-.8Z" />
                <path d="m5 14 .6 1.4L7 16l-1.4.6L5 18l-.6-1.4L3 16l1.4-.6Z" />
            </>
        ),
        calendar: (
            <>
                <rect x="3" y="5" width="18" height="16" rx="2" />
                <path d="M16 3v4M8 3v4M3 10h18" />
            </>
        ),
        order: (
            <>
                <path d="M6 3h12v18H6z" />
                <path d="M9 8h6M9 12h6M9 16h4" />
            </>
        ),
        chart: (
            <>
                <path d="M4 19V9" />
                <path d="M10 19V5" />
                <path d="M16 19v-7" />
                <path d="M22 19H2" />
            </>
        ),
        service: (
            <>
                <rect x="4" y="4" width="16" height="16" rx="3" />
                <path d="M8 9h8M8 13h5M8 17h3" />
            </>
        ),
        close: (
            <>
                <path d="m6 6 12 12M18 6 6 18" />
            </>
        ),
    };

    return (
        <svg
            width={size}
            height={size}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.8"
            strokeLinecap="round"
            strokeLinejoin="round"
            aria-hidden="true"
        >
            {icons[name]}
        </svg>
    );
};

const createWelcomeMessage = () => ({
    id: `welcome-${Date.now()}`,
    role: "assistant",
    content:
        "Hi! I'm your YiPet AI Assistant. I can help you understand bookings, services, orders, customers and other YiPet management data.",
    time: new Date(),
});

const createConversation = () => ({
    id: Date.now(),
    title: "New conversation",
    createdAt: new Date(),
    messages: [createWelcomeMessage()],
});

function AIChat({ username, onClose }) {
    const initialConversation = useMemo(() => createConversation(), []);

    const [conversations, setConversations] = useState([
        initialConversation,
    ]);

    const [activeConversationId, setActiveConversationId] = useState(
        initialConversation.id
    );

    const [inputValue, setInputValue] = useState("");
    const [sending, setSending] = useState(false);

    const messagesEndRef = useRef(null);
    const textareaRef = useRef(null);

    const activeConversation =
        conversations.find(
            (conversation) => conversation.id === activeConversationId
        ) || conversations[0];

    const messages = activeConversation?.messages || [];

    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({
            behavior: "smooth",
        });
    }, [messages, sending]);

    const createNewChat = () => {
        const conversation = createConversation();

        setConversations((previous) => [
            conversation,
            ...previous,
        ]);

        setActiveConversationId(conversation.id);
        setInputValue("");

        window.setTimeout(() => {
            textareaRef.current?.focus();
        }, 100);
    };

    const deleteConversation = (event, conversationId) => {
        event.stopPropagation();

        setConversations((previous) => {
            const remaining = previous.filter(
                (conversation) =>
                    conversation.id !== conversationId
            );

            if (remaining.length === 0) {
                const conversation = createConversation();

                setActiveConversationId(conversation.id);

                return [conversation];
            }

            if (conversationId === activeConversationId) {
                setActiveConversationId(remaining[0].id);
            }

            return remaining;
        });
    };

    const updateConversation = (
        conversationId,
        updater
    ) => {
        setConversations((previous) =>
            previous.map((conversation) =>
                conversation.id === conversationId
                    ? updater(conversation)
                    : conversation
            )
        );
    };

    const sendMessage = async (presetMessage = null) => {
        const content = String(
            presetMessage ?? inputValue
        ).trim();

        if (!content || sending || !activeConversation) {
            return;
        }

        const conversationId = activeConversation.id;

        const userMessage = {
            id: `user-${Date.now()}`,
            role: "user",
            content,
            time: new Date(),
        };

        // Add user message to current conversation
        updateConversation(
            conversationId,
            (conversation) => ({
                ...conversation,

                title:
                    conversation.title === "New conversation"
                        ? content.length > 34
                            ? `${content.slice(0, 34)}...`
                            : content
                        : conversation.title,

                messages: [
                    ...conversation.messages,
                    userMessage,
                ],
            })
        );

        setInputValue("");
        setSending(true);

        try {
            /*
             * ==================================================
             * YiPet AI BACKEND
             * ==================================================
             *
             * Flutter:
             *
             * POST /ai/chat
             * {
             *     "message": message
             * }
             *
             * React Admin uses exactly the same API.
             */

            const response = await api.post("/ai/chat", {
                message: content,
            });

            console.log("AI response:", response.data);

            /*
             * Support several possible response structures.
             *
             * Preferred:
             * {
             *     "message": "AI response..."
             * }
             */

            const aiText =
                response.data?.message ??
                response.data?.data?.message ??
                response.data?.content ??
                response.data?.response ??
                "";

            if (!aiText) {
                throw new Error(
                    "AI service returned an empty response."
                );
            }

            const assistantMessage = {
                id: `assistant-${Date.now()}`,
                role: "assistant",
                content: String(aiText),
                time: new Date(),
            };

            // Add AI response to the SAME conversation
            updateConversation(
                conversationId,
                (conversation) => ({
                    ...conversation,
                    messages: [
                        ...conversation.messages,
                        assistantMessage,
                    ],
                })
            );

        } catch (error) {
            console.error("AI chat error:", error);

            const errorMessage = {
                id: `assistant-error-${Date.now()}`,
                role: "assistant",
                content: getErrorMessage(
                    error,
                    "Sorry, I couldn't connect to the YiPet AI service. Please try again."
                ),
                time: new Date(),
                error: true,
            };

            // Keep the error inside the same conversation
            updateConversation(
                conversationId,
                (conversation) => ({
                    ...conversation,
                    messages: [
                        ...conversation.messages,
                        errorMessage,
                    ],
                })
            );

        } finally {
            setSending(false);

            window.setTimeout(() => {
                textareaRef.current?.focus();
            }, 100);
        }
    };

    const handleKeyDown = (event) => {
        if (
            event.key === "Enter" &&
            !event.shiftKey
        ) {
            event.preventDefault();
            sendMessage();
        }
    };

    const suggestions = [
        {
            icon: "calendar",
            title: "Today's bookings",
            description:
                "Analyse today's appointments and booking activity.",
            prompt:
                "Analyse today's bookings and appointment activity.",
        },
        {
            icon: "order",
            title: "Pending orders",
            description:
                "Check orders that still require attention.",
            prompt:
                "Show me the pending orders that require attention.",
        },
        {
            icon: "chart",
            title: "Platform summary",
            description:
                "Summarise recent activity across YiPet.",
            prompt:
                "Summarise recent YiPet platform activity.",
        },
        {
            icon: "service",
            title: "Service assistant",
            description:
                "Help manage services and service information.",
            prompt:
                "Help me understand and manage YiPet services.",
        },
    ];

    return (
        <section className="ai-chat-page">
            <aside className="ai-chat-history">
                <div className="ai-history-header">
                    <div className="ai-history-brand">
                        <div className="ai-history-logo">
                            <Icon
                                name="sparkles"
                                size={20}
                            />
                        </div>

                        <div>
                            <strong>YiPet AI</strong>
                            <span>Assistant</span>
                        </div>
                    </div>

                    <button
                        type="button"
                        className="ai-new-chat-button"
                        onClick={createNewChat}
                    >
                        <Icon
                            name="plus"
                            size={17}
                        />

                        New Chat
                    </button>
                </div>

                <div className="ai-history-section">
                    <span className="ai-history-label">
                        Conversations
                    </span>

                    <div className="ai-history-list">
                        {conversations.map(
                            (conversation) => (
                                <button
                                    key={
                                        conversation.id
                                    }
                                    type="button"
                                    className={`ai-history-item ${activeConversationId ===
                                        conversation.id
                                        ? "active"
                                        : ""
                                        }`}
                                    onClick={() =>
                                        setActiveConversationId(
                                            conversation.id
                                        )
                                    }
                                >
                                    <span className="ai-history-message-icon">
                                        <Icon
                                            name="message"
                                            size={16}
                                        />
                                    </span>

                                    <span className="ai-history-copy">
                                        <strong>
                                            {
                                                conversation.title
                                            }
                                        </strong>

                                        <small>
                                            {
                                                conversation
                                                    .messages
                                                    .length
                                            }{" "}
                                            messages
                                        </small>
                                    </span>

                                    <span
                                        role="button"
                                        tabIndex={0}
                                        className="ai-delete-chat"
                                        onClick={(
                                            event
                                        ) =>
                                            deleteConversation(
                                                event,
                                                conversation.id
                                            )
                                        }
                                        onKeyDown={(
                                            event
                                        ) => {
                                            if (
                                                event.key ===
                                                "Enter"
                                            ) {
                                                deleteConversation(
                                                    event,
                                                    conversation.id
                                                );
                                            }
                                        }}
                                    >
                                        <Icon
                                            name="trash"
                                            size={14}
                                        />
                                    </span>
                                </button>
                            )
                        )}
                    </div>
                </div>

                <div className="ai-history-footer">
                    <div className="ai-status-dot" />

                    <div>
                        <strong>
                            AI Assistant
                        </strong>

                        <span>
                            Ready to help
                        </span>
                    </div>
                </div>
            </aside>

            <div className="ai-chat-main">
                <header className="ai-chat-header">
                    <div>
                        <div className="ai-chat-title-row">
                            <div className="ai-main-logo">
                                <Icon
                                    name="sparkles"
                                    size={21}
                                />
                            </div>

                            <div>
                                <h1>
                                    YiPet AI Assistant
                                </h1>

                                <p>
                                    Smart support for
                                    your YiPet platform
                                </p>
                            </div>
                        </div>
                    </div>

                    {onClose && (
                        <button
                            type="button"
                            className="ai-close-button"
                            onClick={onClose}
                            aria-label="Close AI Assistant"
                        >
                            <Icon
                                name="close"
                                size={20}
                            />
                        </button>
                    )}
                </header>

                <div className="ai-messages">
                    {messages.length <= 1 && (
                        <div className="ai-welcome">
                            <div className="ai-welcome-icon">
                                <Icon
                                    name="sparkles"
                                    size={30}
                                />
                            </div>

                            <h2>
                                Hi{" "}
                                {username ||
                                    "Admin"}{" "}
                                👋
                            </h2>

                            <p>
                                How can I help you
                                manage YiPet today?
                            </p>

                            <div className="ai-suggestion-grid">
                                {suggestions.map(
                                    (
                                        suggestion
                                    ) => (
                                        <button
                                            key={
                                                suggestion.title
                                            }
                                            type="button"
                                            className="ai-suggestion-card"
                                            onClick={() =>
                                                sendMessage(
                                                    suggestion.prompt
                                                )
                                            }
                                        >
                                            <span className="ai-suggestion-icon">
                                                <Icon
                                                    name={
                                                        suggestion.icon
                                                    }
                                                    size={
                                                        20
                                                    }
                                                />
                                            </span>

                                            <strong>
                                                {
                                                    suggestion.title
                                                }
                                            </strong>

                                            <span>
                                                {
                                                    suggestion.description
                                                }
                                            </span>
                                        </button>
                                    )
                                )}
                            </div>
                        </div>
                    )}

                    <div className="ai-message-list">
                        {messages.map(
                            (message) => (
                                <div
                                    key={message.id}
                                    className={`ai-message-row ${message.role}`}
                                >
                                    {message.role ===
                                        "assistant" && (
                                            <div className="ai-message-avatar assistant">
                                                <Icon
                                                    name="sparkles"
                                                    size={
                                                        17
                                                    }
                                                />
                                            </div>
                                        )}

                                    <div className="ai-message-content">
                                        <div
                                            className={`ai-message-bubble ${message.error
                                                ? "error"
                                                : ""
                                                }`}
                                        >
                                            {
                                                message.content
                                            }
                                        </div>

                                        <span className="ai-message-time">
                                            {new Date(
                                                message.time
                                            ).toLocaleTimeString(
                                                [],
                                                {
                                                    hour: "2-digit",
                                                    minute: "2-digit",
                                                }
                                            )}
                                        </span>
                                    </div>

                                    {message.role ===
                                        "user" && (
                                            <div className="ai-message-avatar user">
                                                {String(
                                                    username ||
                                                    "A"
                                                )
                                                    .charAt(0)
                                                    .toUpperCase()}
                                            </div>
                                        )}
                                </div>
                            )
                        )}

                        {sending && (
                            <div className="ai-message-row assistant">
                                <div className="ai-message-avatar assistant">
                                    <Icon
                                        name="sparkles"
                                        size={17}
                                    />
                                </div>

                                <div className="ai-message-content">
                                    <div className="ai-message-bubble ai-thinking">
                                        <span />
                                        <span />
                                        <span />
                                    </div>
                                </div>
                            </div>
                        )}

                        <div ref={messagesEndRef} />
                    </div>
                </div>

                <div className="ai-composer-area">
                    <div className="ai-composer">
                        <textarea
                            ref={textareaRef}
                            rows={1}
                            value={inputValue}
                            placeholder="Ask YiPet AI anything..."
                            onChange={(event) =>
                                setInputValue(
                                    event.target.value
                                )
                            }
                            onKeyDown={
                                handleKeyDown
                            }
                            disabled={sending}
                        />

                        <button
                            type="button"
                            className="ai-send-button"
                            onClick={() =>
                                sendMessage()
                            }
                            disabled={
                                sending ||
                                !inputValue.trim()
                            }
                            aria-label="Send message"
                        >
                            <Icon
                                name="send"
                                size={18}
                            />
                        </button>
                    </div>

                    <p className="ai-composer-hint">
                        YiPet AI can make mistakes.
                        Verify important management
                        information before taking
                        action.
                    </p>
                </div>
            </div>
        </section>
    );
}

export default AIChat;
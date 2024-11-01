PGDMP       7            	    |            buses_stops    16.4    16.4     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16414    buses_stops    DATABASE        CREATE DATABASE buses_stops WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE buses_stops;
                postgres    false            �            1259    16454    buses    TABLE     �   CREATE TABLE public.buses (
    id integer NOT NULL,
    bus_name character varying(255) NOT NULL,
    start_time time(6) without time zone NOT NULL
);
    DROP TABLE public.buses;
       public         heap    postgres    false            �            1259    16453    buses_id_seq    SEQUENCE     �   CREATE SEQUENCE public.buses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.buses_id_seq;
       public          postgres    false    218            �           0    0    buses_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.buses_id_seq OWNED BY public.buses.id;
          public          postgres    false    217            �            1259    16461    buses_stops    TABLE     �   CREATE TABLE public.buses_stops (
    id integer NOT NULL,
    bus_id integer,
    stop_id integer,
    stop_order integer NOT NULL
);
    DROP TABLE public.buses_stops;
       public         heap    postgres    false            �            1259    16460    buses_stops_id_seq    SEQUENCE     �   CREATE SEQUENCE public.buses_stops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.buses_stops_id_seq;
       public          postgres    false    220            �           0    0    buses_stops_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.buses_stops_id_seq OWNED BY public.buses_stops.id;
          public          postgres    false    219            �            1259    16430    stops    TABLE     f   CREATE TABLE public.stops (
    id integer NOT NULL,
    stop_name character varying(255) NOT NULL
);
    DROP TABLE public.stops;
       public         heap    postgres    false            �            1259    16429    stops_id_seq    SEQUENCE     �   CREATE SEQUENCE public.stops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.stops_id_seq;
       public          postgres    false    216            �           0    0    stops_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.stops_id_seq OWNED BY public.stops.id;
          public          postgres    false    215            %           2604    16457    buses id    DEFAULT     d   ALTER TABLE ONLY public.buses ALTER COLUMN id SET DEFAULT nextval('public.buses_id_seq'::regclass);
 7   ALTER TABLE public.buses ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    218    218            &           2604    16464    buses_stops id    DEFAULT     p   ALTER TABLE ONLY public.buses_stops ALTER COLUMN id SET DEFAULT nextval('public.buses_stops_id_seq'::regclass);
 =   ALTER TABLE public.buses_stops ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    220    220            $           2604    16433    stops id    DEFAULT     d   ALTER TABLE ONLY public.stops ALTER COLUMN id SET DEFAULT nextval('public.stops_id_seq'::regclass);
 7   ALTER TABLE public.stops ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215    216            �          0    16454    buses 
   TABLE DATA           9   COPY public.buses (id, bus_name, start_time) FROM stdin;
    public          postgres    false    218   �       �          0    16461    buses_stops 
   TABLE DATA           F   COPY public.buses_stops (id, bus_id, stop_id, stop_order) FROM stdin;
    public          postgres    false    220   C       �          0    16430    stops 
   TABLE DATA           .   COPY public.stops (id, stop_name) FROM stdin;
    public          postgres    false    216   �       �           0    0    buses_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.buses_id_seq', 5, true);
          public          postgres    false    217            �           0    0    buses_stops_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.buses_stops_id_seq', 16, true);
          public          postgres    false    219            �           0    0    stops_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.stops_id_seq', 5, true);
          public          postgres    false    215            *           2606    16459    buses buses_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.buses
    ADD CONSTRAINT buses_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.buses DROP CONSTRAINT buses_pkey;
       public            postgres    false    218            ,           2606    16466    buses_stops buses_stops_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.buses_stops
    ADD CONSTRAINT buses_stops_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.buses_stops DROP CONSTRAINT buses_stops_pkey;
       public            postgres    false    220            (           2606    16435    stops stops_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.stops
    ADD CONSTRAINT stops_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.stops DROP CONSTRAINT stops_pkey;
       public            postgres    false    216            -           2606    16467 #   buses_stops buses_stops_bus_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.buses_stops
    ADD CONSTRAINT buses_stops_bus_id_fkey FOREIGN KEY (bus_id) REFERENCES public.buses(id);
 M   ALTER TABLE ONLY public.buses_stops DROP CONSTRAINT buses_stops_bus_id_fkey;
       public          postgres    false    4650    218    220            .           2606    16472 $   buses_stops buses_stops_stop_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.buses_stops
    ADD CONSTRAINT buses_stops_stop_id_fkey FOREIGN KEY (stop_id) REFERENCES public.stops(id);
 N   ALTER TABLE ONLY public.buses_stops DROP CONSTRAINT buses_stops_stop_id_fkey;
       public          postgres    false    4648    216    220            �   =   x�3�t*-V��74�4��24�20�2���,�b�P1c�:c��)T�,f`����� +�      �   K   x����0�0L%�8mw��s������Q4ri���i�
^��[mL߽����\��䅳�R9��f�'���7�      �   S   x�3��I���S(.,M,J�2��K-+�άT((�/.H�.�2�J-��)-��*+)JM-�2��/�/�qM9}2������qqq #� A     
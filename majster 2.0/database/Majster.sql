PGDMP         
                {           Majster    15.3    15.3 3    Y           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            Z           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            [           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            \           1262    16563    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                postgres    false            �            1255    16696    delete_alert()    FUNCTION     ~  CREATE FUNCTION public.delete_alert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO alerts_archive (alert_title, alert_who_add_id, alert_details, alert_add_date, alert_machine_id, alert_repairer_id)
    SELECT OLD.alert_title, OLD.alert_who_add_id, OLD.alert_details, OLD.alert_add_date, OLD.alert_machine_id, OLD.alert_repairer_id;

    RETURN OLD;
END;
$$;
 %   DROP FUNCTION public.delete_alert();
       public          postgres    false            �            1255    16694    delete_service()    FUNCTION     �  CREATE FUNCTION public.delete_service() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO serwices_archive (service_title, service_machine_id, service_details, service_start_date, service_end_date, service_user_id)
    SELECT OLD.service_title, OLD.service_machine_id, OLD.service_details, OLD.service_start_date, OLD.service_end_date, OLD.service_user_id;

    RETURN OLD;
END;
$$;
 '   DROP FUNCTION public.delete_service();
       public          postgres    false            �            1255    16698    delete_task()    FUNCTION     z  CREATE FUNCTION public.delete_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO tasks_archive (task_title, task_details, task_add_date, task_start_date, task_end_date, task_start_date_by_user)
    SELECT OLD.task_title, OLD.task_details, OLD.task_add_date, OLD.task_start_date, OLD.task_end_date, OLD.task_start_date_by_user;

    RETURN OLD;
END;
$$;
 $   DROP FUNCTION public.delete_task();
       public          postgres    false            �            1259    16565    users    TABLE     �  CREATE TABLE public.users (
    user_id bigint NOT NULL,
    user_name character varying(100) NOT NULL,
    user_surname character varying(100) NOT NULL,
    user_email character varying(100) NOT NULL,
    user_login character varying(100) NOT NULL,
    user_password character varying(100) NOT NULL,
    user_role character varying(100) DEFAULT USER NOT NULL,
    user_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16572    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            ]           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    16573    alerts    TABLE       CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL,
    alert_machine_id bigint DEFAULT 0,
    alert_status character varying DEFAULT 'Brak'::character varying NOT NULL,
    alert_repairer_id bigint DEFAULT 0
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    16583    alerts_archive    TABLE     �  CREATE TABLE public.alerts_archive (
    alert_archive_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_machine_id bigint DEFAULT 0,
    alert_delete_date timestamp with time zone DEFAULT now() NOT NULL,
    alert_repairer_id bigint DEFAULT 0
);
 "   DROP TABLE public.alerts_archive;
       public         heap    postgres    false    215            �            1259    16592    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    16596    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    218            ^           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    219            �            1259    16597    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    16601    services    TABLE     #  CREATE TABLE public.services (
    service_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date timestamp with time zone NOT NULL,
    service_end_date timestamp with time zone,
    service_exist boolean DEFAULT true NOT NULL,
    service_status character varying(20) DEFAULT 'Nie zaczęte'::character varying,
    service_user_id bigint DEFAULT 0
);
    DROP TABLE public.services;
       public         heap    postgres    false    219            �            1259    16610    serwices_archive    TABLE     �  CREATE TABLE public.serwices_archive (
    service_archive_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date timestamp with time zone NOT NULL,
    service_end_date timestamp with time zone,
    service_delete_data timestamp with time zone DEFAULT now() NOT NULL,
    service_user_id bigint DEFAULT 0
);
 $   DROP TABLE public.serwices_archive;
       public         heap    postgres    false    219            �            1259    16618    tasks    TABLE     �  CREATE TABLE public.tasks (
    task_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date timestamp with time zone NOT NULL,
    task_start_date timestamp with time zone,
    task_end_date timestamp with time zone,
    task_exist boolean DEFAULT true NOT NULL,
    task_start_date_by_user timestamp with time zone
);
    DROP TABLE public.tasks;
       public         heap    postgres    false    219            �            1259    16625    tasks_archive    TABLE     �  CREATE TABLE public.tasks_archive (
    task_archive_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date timestamp with time zone NOT NULL,
    task_start_date timestamp with time zone,
    task_end_date timestamp with time zone,
    task_start_date_by_user timestamp with time zone,
    task_delete_time timestamp with time zone DEFAULT now()
);
 !   DROP TABLE public.tasks_archive;
       public         heap    postgres    false    219            �           2604    16632    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    219    218            �           2604    16633    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            N          0    16573    alerts 
   TABLE DATA           �   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist, alert_machine_id, alert_status, alert_repairer_id) FROM stdin;
    public          postgres    false    216   J       O          0    16583    alerts_archive 
   TABLE DATA           �   COPY public.alerts_archive (alert_archive_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_machine_id, alert_delete_date, alert_repairer_id) FROM stdin;
    public          postgres    false    217   GL       P          0    16592    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    218   �L       R          0    16597    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    220   M       S          0    16601    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    221   6M       T          0    16610    serwices_archive 
   TABLE DATA           �   COPY public.serwices_archive (service_archive_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_delete_data, service_user_id) FROM stdin;
    public          postgres    false    222   �N       U          0    16618    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    223   �O       V          0    16625    tasks_archive 
   TABLE DATA           �   COPY public.tasks_archive (task_archive_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_start_date_by_user, task_delete_time) FROM stdin;
    public          postgres    false    224   �Q       L          0    16565    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   R       _           0    0    machines_machine_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.machines_machine_id_seq', 105, true);
          public          postgres    false    219            `           0    0    users_user_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.users_user_id_seq', 102, true);
          public          postgres    false    215            �           2606    16635    alerts_archive alerts_a_pkay 
   CONSTRAINT     h   ALTER TABLE ONLY public.alerts_archive
    ADD CONSTRAINT alerts_a_pkay PRIMARY KEY (alert_archive_id);
 F   ALTER TABLE ONLY public.alerts_archive DROP CONSTRAINT alerts_a_pkay;
       public            postgres    false    217            �           2606    16637    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    16639    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    218            �           2606    16641    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    220            �           2606    16643    serwices_archive serwic_a_pkay 
   CONSTRAINT     l   ALTER TABLE ONLY public.serwices_archive
    ADD CONSTRAINT serwic_a_pkay PRIMARY KEY (service_archive_id);
 H   ALTER TABLE ONLY public.serwices_archive DROP CONSTRAINT serwic_a_pkay;
       public            postgres    false    222            �           2606    16645    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    221            �           2606    16647    tasks_archive tasks_a_pkay 
   CONSTRAINT     e   ALTER TABLE ONLY public.tasks_archive
    ADD CONSTRAINT tasks_a_pkay PRIMARY KEY (task_archive_id);
 D   ALTER TABLE ONLY public.tasks_archive DROP CONSTRAINT tasks_a_pkay;
       public            postgres    false    224            �           2606    16649    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    223            �           2606    16651    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2620    16697    alerts archive_deleted_alert    TRIGGER     x   CREATE TRIGGER archive_deleted_alert AFTER DELETE ON public.alerts FOR EACH ROW EXECUTE FUNCTION public.delete_alert();
 5   DROP TRIGGER archive_deleted_alert ON public.alerts;
       public          postgres    false    225    216            �           2620    16695    services deleteservice    TRIGGER     t   CREATE TRIGGER deleteservice AFTER DELETE ON public.services FOR EACH ROW EXECUTE FUNCTION public.delete_service();
 /   DROP TRIGGER deleteservice ON public.services;
       public          postgres    false    221    226            �           2620    16699    tasks deletetasktrigger    TRIGGER     s   CREATE TRIGGER deletetasktrigger BEFORE DELETE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.delete_task();
 0   DROP TRIGGER deletetasktrigger ON public.tasks;
       public          postgres    false    227    223            �           2606    16652    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    221    218    3242            �           2606    16657    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    220    3242    218            �           2606    16662    alerts machine_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT machine_fkey FOREIGN KEY (alert_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 =   ALTER TABLE ONLY public.alerts DROP CONSTRAINT machine_fkey;
       public          postgres    false    216    3242    218            �           2606    16667    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    3250    220    223            �           2606    16672    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    214    216    3236            �           2606    16677    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    3236    214    220            N   #  x�}����0�k��R�Z��n w�Sd&3iҐ�&��p<v��<D�%��{E�\�	#�����-P{l�sr�����6
|C�S�m@ʞ(�Q���KD�k�v8N��� ]�>��Mi�8ӆIy>��
��������h�m�F��j�˪���*��XY�o�)�ۓ��m�|��S�?V�ȟ������u�~�4��1̄e(}�̀��-�(�Z7�G��:|u#����u�n'B�+�B��$KڞnG|�FF:��V��#�;Xn �>spV�ub�d���SZ��x���������Nl��þ:"�՘��o��>ć��6��`��p�99DH1�Ӌx�?�x/�pa�",w��B���9��(=7��?�ڏȕ��C��e�E��d^��H���@��AN~��+�F��K"�f�
"�>۴KK|�)>�M�\��/��?��7_{�^��;ߖ/����߲~�7��m���c��$�0t��C�&7�ӗ��1���6D�z�w��^l/]���֭�=���Ζ��T�A�w�M�      O   P   x�340�I-.Q�RH,-�W0������(ZXZZ��ꙙ�i5�$�t-ͬ�H�����"����� ǹ�      P   b   x�32���LW�MLW�L�,.H,O,�N�.(J,�K�,�24��H,��K/�ϋ7q7�,�,H�AWd2���(5�He��8���M8K��4��qqq l+'�      R      x������ � �      S   �  x����N�@�����������Ⰹ1�D���v�e1FI3J���)��X��9J��� Z�BY�<p~ �s1
��!����^������&���X�jd�mu��ܢ2;��GR�|��Cf4��9�E/	Gջ�'Q�C�v�sS��:U�n�k���q�Zót�|N����h��aҡ�&|�Ͳ\��}2�	����2^��>k��j�)'����x u	E��z�;�G5��U�i�K���,Kev}��lO�����)����rqDv�����ؔx-��t�*t�&�$�>.��u�!�8����
Kv�a<����y��F,!�.��zї�G��*�h��Rlԟ*��ds�C�F�}��>x��A�\Q͠��a�|�M�|�9
/      T   �   x����j�0����ɒ,G���.�I!l��d���w�{�M׵���m$����~�O����4;t�!R���QM�(�@�SΆ`D�rj��(&`�A����M������+Cn!hrQ]�]���}��c2B
�=���h�!�>��CҎ��e���lwcq�n=oe7�������ŗ�y����9�GJ�AzLQ���$E�AX�����i���j�      U   �  x��TK��0\�)z�Ԗ����e6-�����c���b����r%I�Ǹ<�#�+��ᅩ A�;��H�R����/@/�[��F7,S}}�r�P*��p�������|�A�+G�y�!45@LN�^r����<.�p[4�$�oՄb��R1!M��re�J�/F����:�^����*U�N5��rܖOeG�5r�t�0ݧ�>�;}��}m�ɺ��5RA����jAʡ���8ƚA�F�}~M�oUv!p�T<�]����!ߢ���C��A�p��@�4 19|a�1 R<ҩ���ŐGcpQ*{����B�6(��U�As��R7��YNn�Mlդ������L��s~��W�AZg��LҀBq�k���d=s�}�yU~i�� ʗ������*=��h:�qzEo��{$#�U�-��{�Y�Ů�h��I{��s��c��y-C��L������ .-      V   W   x�u̻�0E�OA�bَq��?)Q�W�#=&��e�0���F�d�%Q=P5����0)?I:��#���O�R���:4e*\ 7�r$]      L   �   x�u�M
�0�דÔ�?�At#�K7�F��im���x/�M�q�x3���e�G��A���SHh�X�M�(0�^��-�I��`�J�ǫonh"J��)��j���RB��O'o�� �-�Z�Uǭ+.�J����c����.H�&FZޠh��9u�g�N�em�S����O��y�j�������輗O��}{��x���C�� ��     